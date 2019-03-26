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
  end
end
