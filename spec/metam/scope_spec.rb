# encoding: utf-8

require 'spec_helper'
require 'nokogiri'

describe Metam::Scope do

  before(:all) do
    @xsd = Nokogiri::XML::Schema(File.open(Metam.schema))
  end

  before(:each) do
    @scope = Metam::Scope.new('affiliation1')
  end

  it 'creates a Scope with a valid XML' do
    expect(@scope.klasses).not_to be_empty
  end

  it 'raises Exception when invalid XML' do
    expect do
      Metam::Scope.new('affiliation1_faulty')
    end.to raise_error(Metam::Exceptions::InvalidXML)
  end

  it 'returns a Metam::Klass' do
    expect(@scope.klass('User')).to be_a(Metam::Klass)
  end
end
