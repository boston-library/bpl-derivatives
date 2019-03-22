require 'mime/types'

module BPL::Derivatives
  module MimeTypeService
    # @param [String] file_path path to a file
    def self.mime_type(file_path)
      MIME::Types.type_for(file_path).first.to_s
    end
  end
end
