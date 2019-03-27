module BPL::Derivatives
  # This Service is an implementation of the Hydra::Derivatives::PeristOutputFileService
  # It supports basic contained files, which is the behavior associated with Fedora 3 file datastreams that were migrated to Fedora 4
  # and, at the time that this class was authored, corresponds to the behavior of ActiveFedora::Base.attach_file and ActiveFedora::Base.attached_files
  ### Rename this
  class PersistBasicContainedOutputFileService < PersistOutputFileService
    # This method conforms to the signature of the .call method on Hydra::Derivatives::PeristOutputFileService
    # * Persists the file within the object at destination_name
    #
    # NOTE: Uses basic containment. If you want to use direct containment (ie. with PCDM) you must use a different service (ie. Hydra::Works::AddFileToGenericFile Service)
    #
    # @param [BPL::Derivatives::OutputObjectDecorator] content the data to be persisted
    # @param [Hash] directives directions which can be used to determine where to persist to.
    # @option directives [String] url This can determine the path of the object.
    # @option directives [String] format The file extension (e.g. 'jpg')
    def self.call(object, directives)
      file = io(object.content, directives)
      remote_file = retrieve_remote_file(directives)
      remote_file.content = file
      remote_file.mime_type = determine_mime_type(file)
      remote_file.original_name = determine_original_name(file)
      remote_file.save
    end

    # @param file [Hydra::Derivatives::IoDecorator]
    def self.determine_original_name(file)
      if file.respond_to? :original_filename
        file.original_filename
      else
        "derivative"
      end
    end

    # @param file [Hydra::Derivatives::IoDecorator]
    def self.determine_mime_type(file)
      if file.respond_to? :mime_type
        file.mime_type
      else
        "appliction/octet-stream"
      end
    end

    # Override this implementation if you need a remote file from a different location
    # @return [OutputObjectDelegator]
    def self.retrieve_remote_file(directives)
      uri = URI(directives.fetch(:url))
      raise ArgumentError, "#{uri} is not an http uri" unless uri.scheme == 'http'
      BPL::Derivatives.config.output_file_class.constantize.new(uri.to_s)
    end
    private_class_method :retrieve_remote_file

    # @param [IO,String] content the data to be persisted
    # @param [Hash] directives directions which can be used to determine where to persist to.
    # @return [Hydra::Derivatives::IoDecorator]
    def self.io(content, directives)
      charset = charset(content) if directives[:format] == 'txt' || !directives.fetch(:binary, true)
      BPL::Derivatives::IoDecorator.new(content, new_mime_type(directives.fetch(:format), charset))
    end
    private_class_method :io

    def self.new_mime_type(extension, charset = nil)
      fmt = mime_format(extension)
      fmt += "; charset=#{charset}" if charset
      fmt
    end

    # Strings (from FullText) have encoding. Retrieve it
    def self.charset(content)
      content.encoding.name if content.respond_to?(:encoding)
    end
    private_class_method :charset
  end
end
