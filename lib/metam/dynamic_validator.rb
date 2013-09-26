# encoding: utf-8

module Metam

  module DynamicValidator

    def self.get_validators(klazz)
      # { person: { name: { presence: true }, age: { datatype: 'integer' } }, user: { name: { presence: true } } }
      config = DynamicAttribute.get_dynamic_attributes

      # klazz_type   = klazz.to_s.to_sym.downcase
      # class_config = config[klazz_type]
      klazz.instance_eval do
        config.each do |model, attributes|
          attributes.each do |attribute, validators|
            define_method "validate_#{attribute}" do
              puts validators.inspect
            end
          end
        end
      end
    end

  end

end
