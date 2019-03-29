require 'mime/types'

module BPL::Derivatives
  class TempfileService
    def self.create(object, &block)
      new(object).tempfile(&block)
    end

    attr_reader :source_object, :source_file

    def initialize(source_object)
      @source_object = source_object
      @source_file = nil
    end

    def source_file
      if source_object.respond_to? :source_datastream
        @source_file ||= source_object.source_datastream
      else
        @source_file ||= source_object
      end
    end

    def tempfile(&block)
      if source_file.respond_to? :to_tempfile
        source_file.send(:to_tempfile, &block)
      elsif source_file.has_content?
        default_tempfile(&block)
      end
    end

    def default_tempfile(&_block)
      Tempfile.open(filename_for_characterization) do |f|
        f.binmode
        if source_file.content.respond_to? :read
          f.write(source_file.content.read)
        else
          f.write(source_file.content)
        end
        source_file.content.rewind if source_file.content.respond_to? :rewind
        f.rewind
        yield(f)
      end
    end

    protected

    def filename_for_characterization
      if source_file.respond_to? :filename_for_characterization
        source_file.filename_for_characterization
      else
        default_filename_for_characterization
      end
    end

    def default_filename_for_characterization
      registered_mime_type = MIME::Types[source_file.mime_type].first
      BPL::Derivatives.base_logger.warn "Unable to find a registered mime type for #{source_file.mime_type.inspect} on #{source_object.uri}" unless registered_mime_type
      extension = registered_mime_type ? ".#{registered_mime_type.extensions.first}" : ''
      version_id = 1 # TODO: fixme
      m = %r{/([^/]*)$}.match(source_object.uri)
      ["#{m[1]}-#{version_id}", extension.to_s]
    end
  end
end
