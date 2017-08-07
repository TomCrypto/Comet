module Comet
  class Parser
    include Comet::DSL::Helpers
    alias inject instance_exec

    def software(name, depends:, &block)
      raise "software `#{name}' redefined" if @software.key? name
      @software[name] = DSL::Software.new(name, depends: depends, &block)
    end

    def hardware(name, targets:, &block)
      if hardware_defined? name, targets
        raise "hardware `#{name}' redefined for `#{targets}'"
      end
      @hardware[name].push DSL::Hardware.new(name, targets: targets, &block)
    end

    def firmware(name, imports:, &block)
      raise "firmware `#{name}' redefined" if firmware_defined? name
      @firmware.push DSL::Firmware.new(name, imports: imports, &block)
    end

    def array_hash
      Hash.new { |h, k| h[k] = [] }
    end

    def plain_hash
      {}
    end

    def initialize(filename)
      @software = plain_hash
      @hardware = array_hash
      @firmware = []
      @filename = filename
    end

    attr_reader :filename

    def targets
      parse_file! if @targets.nil?
      @targets ||= compute_targets
    end

    def compute_targets
      @firmware.flat_map do |firmware|
        firmware.validate!

        firmware.targets.map do |device|
          [firmware, device]
        end
      end
    end

    private

    def resolve_dependencies!(firmware)
      seen = {}

      firmware.imports = firmware.imports.flat_map do |name|
        resolve! name, seen
      end
    end

    def resolve!(name, seen)
      if seen[name] == :temporary
        raise "circular dependency involving `#{name}' detected"
      end

      object = object_by_name name
      return object if seen[name] == :permanent
      resolve_software! name, object, seen if @software.key? name
      seen[name] = :permanent

      object
    end

    def resolve_software!(name, software, seen)
      seen[name] = :temporary
      software.depends = software.depends.flat_map do |dependency|
        resolve! dependency, seen
      end
    end

    def object_by_name(name)
      if @software[name].nil? && @hardware[name].empty?
        raise "software or hardware `#{name}' undefined"
      end

      @software[name] || @hardware[name]
    end

    def resolve_all_dependencies!
      @firmware.each do |firmware|
        resolve_dependencies! firmware
      end
    end

    def parse_file!
      instance_eval File.read(@filename)
      resolve_all_dependencies!
    end

    def hardware_defined?(name, targets)
      @hardware[name].any? do |hardware|
        hardware.targets == targets
      end
    end

    def firmware_defined?(name)
      @firmware.map(&:name).include? name
    end
  end
end
