require 'spec_helper'
require 'stringio'

describe BPL::Derivatives::DatastreamDecorator do
  before(:all) do
    class GenericObject
      attr_accessor :abstract_datastream
      def initialize(abstract_datastream)
        @abstract_datastream = abstract_datastream
      end
    end

    #Modeled after fedora commons 3 datastream objects
    class AbstractDatastream
      attr_accessor :pid, :mimeType, :dsVersionID, :content
      def initialize(content, mimeType='text/plain')
        @pid = "bpl:#{SecureRandom.hex(6)}"
        @dsVersionID = 1
        @mimeType = mimeType
        @content = content
      end
    end
  end
  let(:file) { StringIO.new('hello') }
  let(:generic_object) {GenericObject.new(datastream)}
  let(:datastream)  {AbstractDatastream.new(file) }

  context "initialization" do
    let(:decorator) { described_class.new(generic_object, "abstract_datastream") }

    describe "attributes" do
      subject {decorator}
      it {is_expected.to respond_to(:source_datastream)}
    end

    describe "access to content#read" do
      subject { decorator.content.read }

      it { is_expected.to eq 'hello' }
    end

    describe "filename_for_characterization" do
      subject { decorator.filename_for_characterization }

      it { is_expected.to include("#{datastream.pid}-#{datastream.dsVersionID}") }
    end
  end
end
