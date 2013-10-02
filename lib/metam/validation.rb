# encoding: utf-8

require 'uri'
require 'date'
module Metam

  #
  # [ module description]
  #
  # @author [author]
  #
  module Validation

    #
    # [ class description]
    #
    # @author [author]
    #
    class Core
      class << self

        #
        # [validate description]
        # @param  klass [type] [description]
        # @param  instance [type] [description]
        #
        # @return [type] [description]
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

    #
    # This class check the Presence of a particular
    #
    # @author [author]
    #
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
          failed(:invalid_datatype_string) unless val.is_a?(String)
        when 'url'
          failed(:invalid_datatype_url) unless val =~ /^#{URI.regexp}$/
        when 'email'
          failed(:invalid_datatype_email) unless val =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        when 'integer'
          failed(:invalid_datatype_integer) unless val.is_a?(Integer)
        when 'float'
          failed(:invalid_datatype_float) unless val =~ /\A\d+\.\d+$/
        when 'date'
          failed(:invalid_datatype_date) unless begin
                                                  Date.parse(val)
                                                rescue
                                                  false
                                                end
        when 'datetime'
          failed(:invalid_datatype_datetime) unless begin
                                                  DateTime.parse(val)
                                                rescue
                                                  false
                                                end
        when 'telephone'
          failed(:invalid_datatype_telephone) unless val =~ /\A^\+[0-9]{6,}$/
        when 'percentage'
          failed(:invalid_datatype_percentage) unless val =~ /\A[0-9]{1,3}$/ && val.to_i.between?(0, 100)
        # TODO: Array Validation
        # when 'array'
        #   failed(:invalid) unless
        # else
        end
      end
    end

    class Minlength < Core
      def perform
      end
    end

    class Maxlength < Core
      def perform
        #return false unless @setting.to_s.length
      end
    end
  end
end
