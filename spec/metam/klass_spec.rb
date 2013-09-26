# encoding: utf-8

require 'spec_helper'

describe Metam::Klass do

  before(:each) do
    @scope = Metam::Scope.new('affiliation1')
  end

  describe 'User klass' do
    before(:each) do
      @klass = @scope.klass('User')
    end

    describe '#attributes' do
      it 'returns :name, :familyname' do
        expect(@klass.attributes).to eq(['name', 'familyname'])
      end
    end
  end

end
