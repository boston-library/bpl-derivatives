module BPL::Derivatives
  class ExtractMetadata < Runner
    def self.transform_directives(options)
      options.each do |directive|
        directive.reverse_merge!(format: 'xml')
      end
      options
    end

    def self.processor_class
      Processors::Metadata
    end

    def self.extract(object, options)
      source_file(object, options) do |f|
        transform_directives(options.delete(:outputs)).each do |instructions|
          processor_class.new(f,
                              instructions.merge(source_file_service: source_file_service),
                              output_file_service: output_file_service,
                              filename_for_characterization: object.filename_for_characterization).process
        end
      end
    end
  end
end
