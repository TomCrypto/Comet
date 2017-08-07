module Comet
  module DSL
    class Firmware
      include Comet::DSL::Helpers
      alias inject instance_exec

      def target(device, &block)
        raise "target #{device} redefined" if @targets.key? device
        @targets[device] = Target.new(device, &block)
      end

      def initialize(name, imports:, &block)
        @name = name
        @imports = imports
        @targets = {}

        instance_exec(&block) if block_given?
      end

      def to_s
        "firmware #{@name}"
      end

      attr_reader :name
      attr_accessor :imports

      def targets
        @targets.keys
      end

      def target_for(device)
        @targets[device]
      end

      def hardware_for(device)
        @imports.flat_map do |imported|
          imported.hardware_for device
        end.uniq
      end

      def validate!
        raise "firmware `#{@name}' has no targets" if @targets.empty?

        @targets.values.each(&:validate!)
        imports.each(&:validate!)

        targets.each do |device|
          validate_for! device, hardware_for(device)
        end
      end

      private

      def validate_for!(device, hardware)
        if hardware.empty?
          raise "firmware `#{@name}' does not support target `#{device}'"
        end

        linkers = hardware.select(&:linker?)
        raise "no linker section for firmware `#{@name}'" if linkers.empty?
        raise "multiple linkers for firmware `#{@name}'" if linkers.length > 1
      end
    end
  end
end
