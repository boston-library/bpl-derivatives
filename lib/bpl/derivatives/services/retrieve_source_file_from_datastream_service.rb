module BPL::Derivatives
  class RetreieveSourceFileFromDatastreamService
    # Retrieves the source
    # @param [BPL::Derivatives::DatastreamDecorator] object the source file is attached to
    # @param [Hash] options
    # @option options [Symbol] :source a method that can be called on the object to retrieve the source file
    # @yield [Tempfile] a temporary source file that has a lifetime of the block
    def self.call(object, options, &block)
      BPL::Derivatives::TempfileService.create(object, &block)
    end
  end
end
