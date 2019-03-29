module BPL::Derivatives
  class PersistDatastreamOutputService < PersistOutputFileService
    def self.call(object, directives)
      datastream = retrieve_datastream(object.original_object, directives)
      datastream.content = object.content
      datastream.mimeType = determine_mime_type(directives.fetch(:format))
      datastream.save
    end

    def self.retrieve_datastream(object, directives)
      dsid = directives.fetch(:dsid)
      raise ArgumentError, "#{dsid} is blank" if dsid.blank?
      output_datastream(object, dsid)
    end
    private_class_method :retrieve_datastream


    def self.output_datastream(object, dsid)
      return object.datastreams[dsid] if object.datastreams[dsid]
      ds = BPL::Derivatives.config.output_file_class.new(object.inner_object, dsid) #ActiveFedora::Datastream
      object.add_datastream(ds)
      ds
    end
    private_class_method :output_datastream
  end
end
