# encoding: utf-8

require 'spec_helper'

describe Metam::Validation::Core do

  before(:each) do
    @user = double(
      'user',
      name: 'john',
      familyname: 'qodiztxcjqzfzwajpznwqodiztxcjqzfzwajpznw',
      birthdate: '05/07/1985',
      time: '12:00:01',
      email: 'john@doe.com',
      zip_code: 101_17, # TODO: change to string than cast to Integer
      ratio: '14.1',
      telephone: '+49198873628',
      website: 'http://www.john.com/',
      distribution_share: '90')
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
      # 4 validations on name: presence, type, maxlength, minlength
      # 4 validations on each other attribute: presence, datatype, maxlength, minlength
      validation = double('validation', perform: true)

      expect(Metam::Validation::Core).to receive(:build).exactly(24).times.and_return(validation)
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

describe Metam::Validation::Datatype do
  describe 'datatype string' do
    it 'should pass' do
      instance = double('user', name: 1234)
      validation = Metam::Validation::Datatype.new(instance, 'name', 'string')

      expect(validation).to receive(:failed).with(:invalid_datatype_string)
      validation.perform
    end

    it 'should fail' do
      instance = double('user', name: 'john')
      validation = Metam::Validation::Datatype.new(instance, 'name', 'string')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end

  describe 'datatype email validation' do
    it 'should fail' do
      instance = double('user', email: 'myemail')
      validation = Metam::Validation::Datatype.new(instance, 'email', 'email')

      expect(validation).to receive(:failed).with(:invalid_datatype_email)
      validation.perform
    end

    it 'should pass' do
      instance = double('user', email: 'john@doe.com')
      validation = Metam::Validation::Datatype.new(instance, 'email', 'email')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end

  describe 'datatype url validation' do
    it 'should fail' do
      instance = double('user', website: 'bla bla')
      validation = Metam::Validation::Datatype.new(instance, 'website', 'url')

      expect(validation).to receive(:failed).with(:invalid_datatype_url)
      validation.perform
    end

    it 'should pass' do
      instance = double('user', website: 'http://www.mediapeers.com/')
      validation = Metam::Validation::Datatype.new(instance, 'website', 'url')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end

  describe 'datatype integer validation' do
    it 'should fail' do
      instance = double('user', zip_code: '101_17')
      validation = Metam::Validation::Datatype.new(instance, 'zip_code', 'integer')

      expect(validation).to receive(:failed).with(:invalid_datatype_integer)
      validation.perform
    end

    it 'should pass' do
      instance = double('user', zip_code: 101_17)
      validation = Metam::Validation::Datatype.new(instance, 'zip_code', 'integer')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end

  describe 'datatype float validation' do
    it 'should fail' do
      instance = double('user', ratio: 'bla')
      validation = Metam::Validation::Datatype.new(instance, 'ratio', 'float')

      expect(validation).to receive(:failed).with(:invalid_datatype_float)
      validation.perform
    end

    it 'should pass' do
      instance = double('user', ratio: '14.1')
      validation = Metam::Validation::Datatype.new(instance, 'ratio', 'float')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end

  describe 'datatype date validation' do
    it 'should fail' do
      instance = double('user', birthdate: '2002/31/12')
      validation = Metam::Validation::Datatype.new(instance, 'birthdate', 'date')

      expect(validation).to receive(:failed).with(:invalid_datatype_date)
      validation.perform
    end

    it 'should pass' do
      instance = double('user', birthdate: '05/07/1985')
      validation = Metam::Validation::Datatype.new(instance, 'birthdate', 'date')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end

  describe 'datatype datetime validation' do
    it 'should fail' do
      instance = double('user', time: '28:12:aa')
      validation = Metam::Validation::Datatype.new(instance, 'time', 'datetime')

      expect(validation).to receive(:failed).with(:invalid_datatype_datetime)
      validation.perform
    end

    it 'should pass' do
      instance = double('user', time: '12:00:01')
      validation = Metam::Validation::Datatype.new(instance, 'time', 'datetime')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end

  describe 'datatype telephone validation' do
    it 'should fail' do
      instance = double('user', telephone: '+12345')
      validation = Metam::Validation::Datatype.new(instance, 'telephone', 'telephone')

      expect(validation).to receive(:failed).with(:invalid_datatype_telephone)
      validation.perform
    end

    it 'should pass' do
      instance = double('user', telephone: '+123456')
      validation = Metam::Validation::Datatype.new(instance, 'telephone', 'telephone')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end

  describe 'datatype percentage validation' do
    it 'should fail' do
      instance = double('user', distribution_share: '1000')
      validation = Metam::Validation::Datatype.new(instance, 'distribution_share', 'percentage')

      expect(validation).to receive(:failed).with(:invalid_datatype_percentage)
      validation.perform
    end

    it 'should pass' do
      instance = double('user', distribution_share: '90')
      validation = Metam::Validation::Datatype.new(instance, 'distribution_share', 'percentage')

      expect(validation).not_to receive(:failed)
      validation.perform
    end
  end
end

describe Metam::Validation::Maxlength do
  it 'should fail' do
    instance = double('user', familyname: 'uvrxcwgojqymmuekvgpqqodiztxcjqzfzwajpznw')
    validation = Metam::Validation::Maxlength.new(instance, 'familyname', '30')

    expect(validation).to receive(:failed).with(:invalid_maxlength)
    validation.perform
  end
end
