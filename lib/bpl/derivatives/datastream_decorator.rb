require 'delegate'
module BPL::Derivatives
  class DatastreamDecorator < SimpleDelegator
    def initialize(datastream)
      super(datastream)
    end

    def to_tempfile(&block)
      return unless has_content?
      Tempfile.open(filename_for_characterization) do |f|
        f.binmode
        if content.respond_to? :read
          f.write(content.read)
        else
          f.write(content)
        end
        content.rewind if content.respond_to? :rewind
        f.rewind
        yield(f, filename_for_characterization)
      end
    end

    def filename_for_characterization
      registered_mime_type = BPL::Derivatives::MimeTypeService.from_datastream(mimeType)
      BPL::Derivatives.base_logger.warn "Unable to find a registered mime type for #{mimeType.inspect} on #{pid}" unless registered_mime_type
      extension = registered_mime_type ? ".#{registered_mime_type.extensions.first}" : ''
      ["#{pid}-#{dsVersionID}", "#{extension}"]
    end
  end
end
