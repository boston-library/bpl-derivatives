require 'delegate'

module BPL::Derivatives
  class OutputObjectDecorator < SimpleDelegator
    attr_accessor :content, :original_object
    def initialize(content, original_object = nil)
      super(content)
      self.content = content
      self.original_object = original_object
    end
  end
end
