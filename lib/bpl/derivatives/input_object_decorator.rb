require 'delegate'

module BPL::Derivatives
  class InputObjectDecorator < SimpleDelegator
    attr_accessor :source_path
    def initialize(object_or_filename)
      self.source_path = object_or_filename if object_or_filename.is_a?(String)
      super(object_or_filename)
    end
  end
end
