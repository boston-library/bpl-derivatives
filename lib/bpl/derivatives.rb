require "bpl/derivatives/version"

module BPL
  module Derivatives
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    class Error < StandardError; end
    class TimeoutError < ::Timeout::Error; end


    autoload :Config
    autoload :Logger



    def self.config
      @config ||= reset_config!
    end

    def self.reset_config!
      @config = Config.new
    end


    Config::CONFIG_METHODS.each do |method|
       module_eval <<-RUBY
         def self.#{method}
           config.#{method}
         end
         def self.#{method}=(val)
           config.#{method}=(val)
         end
       RUBY
    end
  end
end
