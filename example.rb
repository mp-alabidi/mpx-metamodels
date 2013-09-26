require 'nokogiri'

@xml = Nokogiri::XML(File.open('spec/data/affiliation1.xml'))
