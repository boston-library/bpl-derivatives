require 'spec_helper'

describe BPL::Derivatives::Processors::Processor do
  subject { described_class.new(file_object, directives) }

  let(:object)        { "Fake Object" }
  let(:source_name)   { 'content' }
  let(:directives)    { { thumb: "100x100>" } }
  let(:file_object)   { BPL::Derivatives::InputObjectDecorator.new('/foo/bar/path.txt') }

  describe "output_file_service" do
    let(:custom_output_file_service) { "fake service" }
    let(:another_custom_output_file_service) { "another fake service" }

    context "with a global configuration setting" do
      before do
        allow(BPL::Derivatives.config).to receive(:output_file_service).and_return(custom_output_file_service)
      end
      it "utilizes the default output file service" do
        expect(subject.output_file_service).to eq(custom_output_file_service)
      end
    end

    context "with an instance level configuration setting" do
      subject do
        described_class.new(BPL::Derivatives::InputObjectDecorator.new('/opt/derivatives/foo.mp4'), directives,
                            output_file_service: another_custom_output_file_service)
      end

      it "accepts a custom output file service as an option" do
        expect(subject.output_file_service).to eq(another_custom_output_file_service)
      end
    end
  end
end
