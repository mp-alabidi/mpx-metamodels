# encoding: utf-8

module Metam
  class Klass
    def initialize(klass_name, xml_element)
      @name = klass_name
      @xml  = xml_element
      @attributes = {}

      @xml.xpath('attributes/attribute').each do |el|
        initialize_attribute(el)
      end
    end

    def initialize_attribute(xml_element)
      attr_name        = xml_element.xpath('title').text.downcase
      attr_validations = xml_element.xpath('validators/*').inject({}) do |hsh, validation| 
        hsh.update(validation.name => validation.text)
      end

      @attributes[attr_name] = Metam::Attribute.new(attr_name, attr_validations)
    end

    def attribute(attribute_name)
      @attributes[attribute_name.to_s]
    end

    def attributes
      @attributes.keys
    end
  end

  class Attribute
    attr_reader :name, :validations

    def initialize(name, validations)
      @name = name
      @validations = validations
    end 
  end
end
