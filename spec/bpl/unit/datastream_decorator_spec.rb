require 'spec_helper'
require 'stringio'

describe BPL::Derivatives::DatastreamDecorator do
  before(:all) do
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
  let(:datastream)  {AbstractDatastream.new(file) }

  context "initialization" do
    let(:decorator) { described_class.new(datastream) }

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
