require 'spec_helper'

describe "the configuration" do
  subject { BPL::Derivatives::Config.new }

  before do
    # It's not always /tmp; it depends on OS and ENV vars
    allow(Dir).to receive(:tmpdir).and_return('/tmp')
  end

  it "has some configuration defaults" do
    expect(subject.ffmpeg_path).to eq('ffmpeg')
    expect(subject.enable_ffmpeg).to be true
    expect(subject.libreoffice_path).to eq('soffice')
    expect(subject.temp_file_base).to eq('/tmp')
    expect(subject.fits_path).to eq('fits.sh')
    expect(subject.kdu_compress_path).to eq('kdu_compress')
    expect(subject.output_file_service).to eq(BPL::Derivatives::PersistBasicContainedOutputFileService)
    expect(subject.source_file_service).to eq(BPL::Derivatives::RetrieveSourceFileService)
    expect(subject.base_logger).to be_a_kind_of(::Logger)
    expect(subject.output_object_class).to eq("ActiveFedora::File")
  end

  it "lets you change the configuration" do
    subject.ffmpeg_path = '/usr/local/ffmpeg-1.0/bin/ffmpeg'
    expect(subject.ffmpeg_path).to eq('/usr/local/ffmpeg-1.0/bin/ffmpeg')

    subject.kdu_compress_path = '/opt/local/bin/kdu_compress'
    expect(subject.kdu_compress_path).to eq('/opt/local/bin/kdu_compress')

    subject.enable_ffmpeg = false
    expect(subject.enable_ffmpeg).to be false
  end

  it "lets you set a custom output file service" do
    output_file_service = instance_double("MyOutputFileService")
    subject.output_file_service = output_file_service
    expect(subject.output_file_service).to eq(output_file_service)
  end

  it "lets you set a custom source file service" do
    source_file_service = instance_double("MyRetriveSourceFileService")
    subject.source_file_service = source_file_service
    expect(subject.source_file_service).to eq(source_file_service)
  end
end
