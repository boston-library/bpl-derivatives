require 'tmpdir'

module BPL::Derivatives
  class Config
    CONFIG_METHODS = %i[ffmpeg_path libreoffice_path temp_file_base fits_path kdu_compress_path
                       kdu_compress_recipes enable_ffmpeg source_file_service output_file_service active_encode_poll_time output_object_class].freeze

    attr_accessor :ffmpeg_path, :libreoffice_path, :temp_file_base,
                :source_file_service, :output_file_service, :fits_path,
                :enable_ffmpeg, :kdu_compress_path, :kdu_compress_recipes,
                :active_encode_poll_time, :base_logger, :output_object_class

    def initialize
      @ffmpeg_path ||= 'ffmpeg'
      @libreoffice_path ||= 'soffice'
      @temp_file_base ||= Dir.tmpdir
      @source_file_service ||= BPL::Derivatives::RetrieveSourceFileService
      @output_file_service ||= BPL::Derivatives::PersistBasicContainedOutputFileService
      @fits_path ||= 'fits.sh'
      @enable_ffmpeg = nil
      @kdu_compress_path ||= 'kdu_compress'
      @kdu_compress_recipes ||= {
        default_color: %(-rate 2.4,1.48331273,.91673033,.56657224,.35016049,.21641118,.13374944,.08266171
          -jp2_space sRGB
          -double_buffering 10
          -num_threads 4
          -no_weights
          Clevels=6
          Clayers=8
          "Cblk={64,64}"
          Cuse_sop=yes
          Cuse_eph=yes
          Corder=RPCL
          ORGgen_plt=yes
          ORGtparts=R
          "Stiles={1024,1024}" ).gsub(/\s+/, " ").strip,
        default_grey: %(-rate 2.4,1.48331273,.91673033,.56657224,.35016049,.21641118,.13374944,.08266171
          -jp2_space sLUM
          -double_buffering 10
          -num_threads 4
          -no_weights
          Clevels=6
          Clayers=8
          "Cblk={64,64}"
          Cuse_sop=yes
          Cuse_eph=yes
          Corder=RPCL
          ORGgen_plt=yes
          ORGtparts=R
          "Stiles={1024,1024}" ).gsub(/\s+/, " ").strip
      }
      @active_encode_poll_time ||= 10
      @base_logger ||= ::Logger.new(STDOUT)
      @output_object_class ||= "ActiveFedora::File"
    end

    def enable_ffmpeg
      return @enable_ffmpeg unless @enable_ffmpeg.nil?
      @enable_ffmpeg = true
    end
  end
end
