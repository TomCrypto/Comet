require 'require_all'

require_rel '.'

module Comet
  TMPDIR = '.comet'.freeze

  class Generator
    def initialize(filename)
      @filename = filename
    end

    attr_reader :filename

    def build_file
      @build_file ||= find_build_file File.expand_path('.')
    end

    def makefile
      @makefile ||= create_makefile
    end

    private

    def parser
      @parser ||= Parser.new build_file
    end

    def create_makefile
      makefile = Makefile.new
      raise "no build file '#{filename}' found" if build_file.nil?
      Dir.chdir File.dirname(build_file)
      makefile.alias 'all', make_rules(makefile)
      makefile.clean
      makefile
    rescue => ex
      makefile.error ex.message
      makefile
    end

    # TODO: implement this for Windows

    def filesystem_of(path)
      `stat -f -c '%i' "#{path}"`
    end

    def same_filesystem?(path1, path2)
      filesystem_of(path1) == filesystem_of(path2)
    end

    def find_build_file(path)
      return File.join(path, filename) if File.exist? File.join(path, filename)

      parent = File.expand_path '..', path
      return nil unless same_filesystem? path, parent
      return nil if parent == '/'

      find_build_file parent
    end

    def make_rules(makefile)
      firmwares = Hash.new { |h, k| h[k] = [] }

      parser.targets.map do |firmware, device|
        firmwares[firmware].push makefile.build(firmware, device)
        makefile.alias "#{firmware.name}/#{device}", [
          firmwares[firmware].last
        ]
      end

      firmwares.map do |firmware, devices|
        makefile.alias firmware.name, devices
      end
    end
  end
end
