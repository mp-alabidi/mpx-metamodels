# encoding: utf-8

module Metam
  class Store
    include Singleton

    def initialize
      @scopes = {}
    end

    def scope(scope_name)
      @scopes[scope_name] ||= Metam::Scope.new(scope_name)
    end
  end
end
