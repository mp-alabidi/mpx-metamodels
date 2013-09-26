# encoding: utf-8

require 'spec_helper'

describe Metam::Validation::Core do

  before(:each) do
    @user = double('user', name: 'john', familyname: 'doe')
    @scope = Metam::Scope.new('affiliation1')
    @klass = @scope.klass('User')
  end

  describe '.validate' do
    it 'passes' do
      expect do
        Metam::Validation::Core.validate(@klass, @user)
      end.not_to raise_error
    end

    it 'calls .build for all validations' do
      # 2 validations on name: presence, type
      # 2 validations on familyname: presence, type
      validation = double('validation', perform: true)

      expect(Metam::Validation::Core).to receive(:build).exactly(4).times.and_return(validation)
      Metam::Validation::Core.validate(@klass, @user)
    end
  end
end

describe Metam::Validation::Presence do
  describe 'with presence = true' do
    it 'should fail' do
      instance = double('user', name: '')
      validation = Metam::Validation::Presence.new(instance, 'name', 'true')

      expect(validation).to receive(:failed).with(:blank)
      validation.perform
    end

    it 'should pass' do
      instance = double('user', name: 'foo')
      validation = Metam::Validation::Presence.new(instance, 'name', 'true')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end

  describe 'with presence = false' do
    it 'should pass' do
      instance = double('user', name: '')
      validation = Metam::Validation::Presence.new(instance, 'name', 'false')

      expect(validation).not_to receive(:failed)
      validation.perform
    end

    it 'should pass as well' do
      instance = double('user', name: 'foo')
      validation = Metam::Validation::Presence.new(instance, 'name', 'false')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end
end
