# encoding: utf-8

require 'spec_helper'

describe Metam::Store do

  before(:each) do
    @store = Metam::Store.instance
  end

  it 'returns a Metam::Scope' do
    expect(@store.scope('affiliation1')).to be_a(Metam::Scope)
  end
end

