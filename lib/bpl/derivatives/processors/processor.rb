module BPL::Derivatives::Processors
  # Processors take a single input and produce a single output
  class Processor
    attr_accessor :object, :source_path, :directives, :output_file_service

    # @param [BPL::Derivatives::InputObjectDecorator,BPL::Derivatives::OutputObjectDelegator]
    # @param [Hash] directives directions for creating the output
    # @option [String] :format the format of the output
    # @option [String] :url the location to put the output
    # @param [Hash] opts
    # @option [#call] :output_file_service An output file service to call
    def initialize(object, directives, opts = {})
      self.object = object
      self.source_path = object.source_path
      self.directives = directives
      self.output_file_service = opts.fetch(:output_file_service, BPL::Derivatives.config.output_file_service)
    end

    def process
      raise "Processor is an abstract class. Implement `process' on #{self.class.name}"
    end

    # This governs the output key sent to the persist file service
    # while this is adequate for storing in Fedora, it's not a great name for saving
    # to the file system.
    def output_file_id(name)
      [out_prefix, name].join('_')
    end

    def output_filename_for(_name)
      File.basename(source_path)
    end

    def finalize_derivative_output(output_io)
      output_object = BPL::Derivatives::OutputObjectDecorator.new(output_io, object)
      output_file_service.call(output_object, directives)
    end
    # @deprecated Please use a PersistOutputFileService class to save an object
    def output_file
      raise NotImplementedError, "Processor is an abstract class. Utilize an implementation of a PersistOutputFileService class in #{self.class.name}"
    end
  end
end
