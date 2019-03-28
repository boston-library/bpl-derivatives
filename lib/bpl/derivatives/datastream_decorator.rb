require 'delegate'
module BPL::Derivatives
  class DatastreamDecorator < InputObjectDecorator
    attr_accessor :source_datastream
    def initialize(object, source_datastream_name)
      super(object)
      self.source_datastream = object.send(source_datastream_name)
    end

    def content
      self.source_datastream.content
    end

    def has_content?
      self.source_datastream.has_content?
    end

    def filename_for_characterization
      return source_datastream.filename_for_characterization if source_datastream.respond_to?(:filename_for_characterization)
      self.default_filename_for_charaterization
    end

    protected
    def default_filename_for_charaterization
      registered_mime_type = BPL::Derivatives::MimeTypeService.type_lookup(source_datastream.mimeType)
      BPL::Derivatives.base_logger.warn "Unable to find a registered mime type for #{source_datastream.mimeType.inspect} on #{pid}" unless registered_mime_type
      extension = registered_mime_type ? ".#{registered_mime_type.extensions.first}" : ''
      ["#{source_datastream.pid}-#{source_datastream.dsVersionID}", "#{extension}"]
    end
  end
end
