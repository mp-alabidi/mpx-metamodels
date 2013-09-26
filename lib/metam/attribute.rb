# encoding: utf-8

module Metam
  class Attribute
    attr_reader :name, :validations

    def initialize(name, validations)
      @name = name
      @validations = validations
    end
  end
end
