# module as namespace
module Juden
  require 'singleton'
  # read keymap from yaml file
  class Config
    include Singleton

    attr_reader :keymap
    attr_accessor :custom_path

    def initialize
      @custom_path = nil
      reload
    end

    def reload
      @cache  = nil
      @keymap = YAML.load_file(file_path)
      self
    end

    def threshold_percentage
      keymap['threshold_percentage']
    end

    def interval_seconds
      keymap['interval_seconds']
    end

    def webhook_url
      keymap['webhook_url']
    end

    def device_name
      keymap['device_name']
    end

    private

    def file_path
      filename = 'juden/config.yml'
      if File.exist?(expand_config_path(filename))
        expand_config_path(filename)
      else
        puts "Please create your config file to #{expand_config_path(filename)}"
        puts "\n"
        puts 'Please copy beloiw to ~/.config/juden/config.yml'
        puts "\n"
        puts "--------------------------------------------------------"
        puts File.read(expand_sample_path)
        puts "--------------------------------------------------------"
        puts "\n"
        puts 'Then, pelase edit ~/.config/juden/config.yml for your Environment'
        puts "\n"
        exit 1
      end
    end

    def expand_config_path(filename)
      File.expand_path "#{Dir.home}/.config/#{filename}"
    end

    def expand_sample_path
      File.expand_path '../../../config.yml', __FILE__
    end
  end
end
