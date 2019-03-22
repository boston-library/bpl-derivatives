require 'delegate'

module BPL::Derivatives
    class IoDecorator < SimpleDelegator
      attr_accessor :mime_type, :original_filename
      alias original_name original_filename
      alias original_name= original_filename=

      def initialize(file, mime_type = nil, original_filename = nil)
        super(file)
        self.mime_type = mime_type
        self.original_filename = original_filename
      end
    end
  end
end
