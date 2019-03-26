module BPL::Derivatives
  class PersistOutputFileService
    # Persists the file within the object at destination_name.  Uses basic containment.
    # If you want to use direct containment (ie. with PCDM) you must use a different service (ie. Hydra::Works::AddFileToGenericFile Service)
    # @param [String] file_path the path to the file to be added
    # @param [Hash] directives directions which can be used to determine where to persist to.
    # @option directives [String] url This can determine the path of the object.
    def self.call(__object_or_file_path, _directives)
      raise NotImplementedError, "PersistOutputFileService is an abstract class. Implement `call' on #{self.class.name}"
    end
  end
end
