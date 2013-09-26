# encoding: utf-8
require 'singleton'
require 'crack/xml'

module Metam

  class Definitions
    include Singleton

    def initialize
      @cache = {}
    end

    # returns a klass attribute & validation definition for a specified
    # scope (affiliation)
    def klass_definition(scope, klass)

    end

    def scope_definition(scope)
      @cache[scope] ||= begin
          Crack::XML.parse(File.read(File.join(Metam.data_dir, "#{scope}.xml")))
        end
    end

  end

end
