require "bpl/derivatives/version"
require 'awesome_print'
require 'active_support'

module BPL
  module Derivatives
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    class Error < StandardError; end
    class TimeoutError < ::Timeout::Error; end



    autoload_under 'runners' do
      # autoload :ActiveEncodeDerivatives
      # autoload :AudioDerivatives
      autoload :DocumentDerivatives
      autoload :ImageDerivatives
      autoload :Jpeg2kImageDerivatives
      autoload :PdfDerivatives
      autoload :Runner
      autoload :VideoDerivatives
    end


    autoload :Config
    autoload :Logger
    autoload :Processors
    autoload :TempfileService
    autoload :DatastreamTempfileService
    autoload :IoDecorator
    autoload :DatastreamDecorator
    autoload :AudioEncoder


    autoload_under 'services' do
      autoload :RetrieveSourceFileService
      # autoload :RemoteSourceFile
      autoload :PersistOutputFileService
      autoload :PersistBasicContainedOutputFileService
      autoload :PersistExternalFileOutputFileService
      autoload :TempfileService
      autoload :DatastreamTempfileService
      autoload :MimeTypeService
    end

    @@config = Config.new
    mattr_reader :config

    def self.configure
      yield(config) if block_given?
    end

    def self.reset_config!
      @@config = Config.new
    end

    class_methods do
      def config
        @@config ||= Config.new
      end
    end

    def config
      self.class.config
    end

    def derivatize(datastream_name, transform_directives, opts={})
      runner = opts[:runner] ? opts.delete(:runner) : :image
      "BPL::Derivatives::#{runner.to_s.classify}".constantize.new(self, transform_directives,op)
    end

  end
end
