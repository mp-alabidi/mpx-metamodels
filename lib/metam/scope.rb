# encoding: utf-8
require 'nokogiri'

module Metam

  # This class defines a scope of
  class Scope
    def initialize(scope_name)
      @klasses  = {}
      @path     = File.join(Metam.data_dir, "#{scope_name}.xml")
      @xml      = Nokogiri::XML(File.open(@path))

      @xml.xpath('/root/model').each do |el|
        initialize_klass(el)
      end
    rescue
      raise Metam::Exceptions::UnknownScope, "scope unknown: #{scope_name}"
    end

    def initialize_klass(xml_element)
      klass_name = xml_element.xpath('name').text
      klass = Metam::Klass.new(klass_name, xml_element)

      @klasses[klass_name] = klass
    end

    def klass(klass_name)
      @klasses[klass_name]
    end
  end
end
