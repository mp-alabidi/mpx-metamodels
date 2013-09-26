# encoding: utf-8

require 'spec_helper'

describe Metam::Store do

  before(:each) do
    @scope = Metam::Scope.new('affiliation1')
  end

  it 'returns a Metam::Klass' do
    expect(@scope.klass('User')).to be_a(Metam::Klass)
  end
end
