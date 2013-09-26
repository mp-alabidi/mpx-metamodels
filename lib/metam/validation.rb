# encoding: utf-8

module Metam
  module Validation
    class Core
      class << self
        def validate(klass, instance)
          klass.attributes.each do |attr|
            attr.validations.each do |validation, setting|
              implementation = build(instance, attr, validation, setting)
              implementation.perform
            end
          end
        end

        private

        def build(instance, attr, validation_name, setting)
          implementation = "Metam::Validation::#{validation_name.camelcase}".constantize
          implementation.new(instance, attr.name, setting)
        end
      end

      def initialize(instance, instance_attr, setting = '')
        @instance = instance
        @attr     = instance_attr
        @setting  = setting
      end

      def val
        @instance.send(@attr)
      end

      def failed(reason)
        @instance.errors.add(@attr, reason)
      end
    end

    class Presence < Core
      def perform
        return if @setting == 'false'
        failed(:blank) if val.blank?
      end
    end

    class Datatype < Core
      def perform
        case @setting
        when 'string'
          failed(:invalid) unless val.is_a?(String)
        end
      end
    end
  end
end
