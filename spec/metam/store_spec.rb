# encoding: utf-8

require 'spec_helper'
require 'nokogiri'

describe Metam::Store do

  before(:each) do
    @store        = Metam::Store.instance
    # @scope        = @store.scope('affiliation1')
    # @scope_faulty = @store.scope('affiliation1_faulty')
  end

  it 'returns a Metam::Scope' do
    expect(@store.scope('affiliation1')).to be_a(Metam::Scope)
  end

  it 'fails when scope is invalid' do
    expect do
      @store.scope('affiliation1_faulty')
    end.to raise_error(Metam::Exceptions::InvalidXML)
  end
end
