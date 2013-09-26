# encoding: utf-8

Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), 'metam/**/*')).each do |file|
  require file unless File.directory?(file)
end

module Metam
  def self.data_dir=(dir)
    @data_dir = dir
  end

  def self.data_dir
    @data_dir
  end
end
