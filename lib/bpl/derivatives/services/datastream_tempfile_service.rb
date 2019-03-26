require 'mime/types'

module BPL::Derivatives
  class DatastreamTempfileService < BPL::Derivatives::TempfileService
    attr_reader :source_datastream
    def self.create(datastream, &block)
      new(datastream).tempfile(&block)
    end

    # @param [DatastreamDecorator] datastream for file object
    def initialize(datastream)
      @source_datastream = datastream
    end

    def tempfile(&block)
      source_datastream.to_tempfile(&block) #No need to check if it responds to to_tempfile as the Datastream decrator takes care of this
    end
  end
end
