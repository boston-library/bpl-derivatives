require 'spec_helper'

describe BPL::Derivatives do
  it "has a version number" do
    expect(BPL::Derivatives::VERSION).not_to be nil
  end

  before(:all) do
    class CustomFile
      include BPL::Derivatives
    end
  end

  after(:all) { Object.send(:remove_const, :CustomFile) }

  describe "source_file_service" do
    before { subject.config.source_file_service = custom_source_file_service }

    context "with a global configuration setting" do
      subject { CustomFile }

      let(:custom_source_file_service) { "fake service" }

      it "utilizes the default source file service" do
        expect(subject.config.source_file_service).to eq(custom_source_file_service)
      end
    end

    context "with an instance level configuration setting" do
      subject { CustomFile.new }

      let(:custom_source_file_service) { "another fake service" }

      it "accepts a custom source file service as an option" do
        expect(subject.config.source_file_service).to eq(custom_source_file_service)
      end
    end
  end

  BPL::Derivatives::Config::CONFIG_METHODS.each do |method|
    describe method.to_s do
      it 'returns the config value' do
        expect(subject.config.send(method)).to eq subject.config.send(method)
      end
    end
    describe "#{method}=" do
      it 'stores config changes' do
        expect { subject.config.send("#{method}=", "new_value") }.to change { subject.config.send(method) }.from(subject.config.send(method)).to("new_value")
      end
    end
  end

  describe 'configure' do
    it "resets the configuration" do
      subject.config.ffmpeg_path = '/usr/local/ffmpeg-1.0/bin/ffmpeg'
      subject.reset_config!
      expect(subject.config.ffmpeg_path).to eq('ffmpeg')

      subject.config.kdu_compress_path = '/usr/local/bin/kdu_compress'
      subject.reset_config!
      expect(subject.config.kdu_compress_path).to eq('kdu_compress')

      subject.config.active_encode_poll_time = 2
      subject.reset_config!
      expect(subject.config.active_encode_poll_time).to eq 10
    end

    it "lets you set configuration via block" do
      subject.configure do |config|
        config.ffmpeg_path = '/usr/local/ffmpeg-1.0/bin/ffmpeg'
        config.kdu_compress_path = '/usr/local/bin/kdu_compress'
        config.source_file_service = "MySourceCustomService"
        config.output_file_service = "MyOutputService"
      end
      expect(subject.config.ffmpeg_path).to eq('/usr/local/ffmpeg-1.0/bin/ffmpeg')
      expect(subject.config.kdu_compress_path).to eq('/usr/local/bin/kdu_compress')
      expect(subject.config.source_file_service).to eq("MySourceCustomService")
      expect(subject.config.output_file_service).to eq("MyOutputService")
    end
  end
end
