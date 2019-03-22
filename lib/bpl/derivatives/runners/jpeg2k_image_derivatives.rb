module BPL::Derivatives
  class Jpeg2kImageDerivatives < Runner
    # # Adds format: 'png' as the default to each of the directives
    def self.transform_directives(options)
      options.each do |directive|
        directive.reverse_merge!(format: 'jp2')
      end
      options
    end

    def self.processor_class
      Processors::Jpeg2kImage
    end
  end
end
