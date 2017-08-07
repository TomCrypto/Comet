require 'digest'
require 'set'

module Comet
  class Makefile
    def initialize
      @rules = [tmpdir_rule]
    end

    def contents
      (commands + @rules.map(&:contents)).flatten.join "\n"
    end

    def execute(*args)
      process_spawn make_command(*args) do |stdin|
        stdin.write contents
      end
    end

    def alias(name, rules)
      insert Rules::Alias.new(name, rules)
    end

    def build(firmware, device)
      append Rules::Build.new(firmware, device)
    end

    def error(message)
      insert Rules::Error.new(message)
    end

    def clean
      append Rules::Clean.new(Comet::TMPDIR)
    end

    private

    def tmpdir_rule
      @tmpdir_rule ||= Rules::TmpDir.new
    end

    def insert(rule)
      @rules.unshift rule unless seen? rule
      rule.rules.each(&method(:append))
      rule
    end

    def append(rule)
      @rules.push rule unless seen? rule
      rule.rules.each(&method(:append))
      rule
    end

    def seen?(rule)
      @rules.map(&:target).include? rule.target
    end

    def process_spawn(arguments)
      IO.pipe do |read, write|
        process = spawn(*arguments, in: read)
        yield write # pass in process stdin
        write.close # make sure to close
        Process.wait process
      end

      $?.exitstatus
    end

    def commands
      commands = @rules.map(&:commands).reduce(&:merge)
      commands.flat_map do |name, default|
        ["#{name} ?= #{default}"]
      end
    end

    def make_command(arguments, verbose: false)
      [
        ENV.fetch('MAKE', 'make'),
        verbose ? nil : '-s',
        '-f', '-', *arguments
      ].compact
    end

    # Make utilities (TODO: move this elsewhere?)

    class << self
      def select_command(preferred, alternate, args)
        return command(alternate, args) if preferred == alternate

        check_command = "(command -v #{preferred} > /dev/null)"
        preferred_cmd = command preferred, args
        alternate_cmd = command alternate, args

        "#{check_command} && #{preferred_cmd} || #{alternate_cmd}"
      end

      def command(command, args)
        [command, *args].join ' '
      end

      def fingerprint(dependencies, extension:)
        File.join Comet::TMPDIR, "#{hash dependencies}.#{extension}"
      end

      private

      def hash(object)
        digest = Digest::SHA256.new

        if [Array, Set, Hash].any? { |t| object.is_a? t }
          hash_container digest, container: object
        else
          digest.update Digest::SHA256.digest(object.class.name)
          digest.update Digest::SHA256.digest(object.to_s)
        end

        digest.hexdigest[0..19]
      end

      def hash_container(digest, container:)
        if container.is_a? Array
          container.each { |element| digest.update hash(element) }
        else # this will work for both hashes and sets
          digest.update hash(container.to_a.sort)
        end
      end
    end
  end
end
