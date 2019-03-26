module BPL
  module Derivatives
    class Runner
      class << self
        attr_writer :output_file_service
      end

      # Use the output service configured for this class or default to the global setting
      def self.output_file_service
        @output_file_service || BPL::Derivatives.config.output_file_service
      end

      class << self
        attr_writer :source_file_service
      end

      # Use the source service configured for this class or default to the global setting
      def self.source_file_service
        @source_file_service || BPL::Derivatives.config.source_file_service
      end

      # @param [String, ActiveFedora::Base] object_or_filename path to the source file, or an object
      # @param [Hash] options options to pass to the encoder
      # @options options [Array] :outputs a list of desired outputs, each entry is a hash that has :label (optional), :format and :url
      def self.create(object_or_filename, options)
        io_object = input_object(object_or_filename)
        source_file(io_object, options) do |f|
          io_object.source_path = f.path
          transform_directives(options.delete(:outputs)).each do |instructions|
            processor_class.new(io_object,
                                instructions.merge(source_file_service: source_file_service),
                                output_file_service: output_file_service).process
          end
        end
      end

      def self.input_object(object_or_filename, options)
        if options.key?(:source_datastream)
          return BPL::Derivatives::DatastreamDecorator.new(object_or_filename, opts.fetch(:source_datastream))
        else
          return BPL::Derivatives::InputObjectDecorator.new(object_or_filename)
        end
      end

      # Override this method if you need to add any defaults
      def self.transform_directives(options)
        options
      end

      def self.source_file(object_or_filename, options, &block)
        source_file_service.call(object_or_filename, options, &block)
      end

      def self.processor_class
        raise "Overide the processor_class method in a sub class"
      end
    end
  end
end
