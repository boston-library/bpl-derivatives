require "bpl/derivatives/version"
require 'active_support/all'


module BPL
  module Derivatives
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    class Error < StandardError; end
    class TimeoutError < ::Timeout::Error; end



    autoload_under 'runners' do
      autoload :AudioDerivatives
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
    autoload :IoDecorator
    autoload :InputObjectDecorator
    autoload :DatastreamDecorator
    autoload :OutputObjectDecorator
    autoload :AudioEncoder


    autoload_under 'services' do
      autoload :RetrieveSourceFileService
      autoload :PersistOutputFileService
      autoload :PersistBasicContainedOutputFileService
      autoload :PersistDatastreamOutputService
      autoload :PersistFileSystemOutputService
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

    def derivatize(opts={})
      runner = opts[:runner] ? opts.delete(:runner) : :image
      "BPL::Derivatives::#{runner.to_s.classify}".constantize.new(self, opts)
    end
  end
end
