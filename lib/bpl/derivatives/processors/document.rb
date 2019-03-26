module BPL::Derivatives::Processors
  class Document < Processor
    include ShellBasedProcessor

    def self.encode(path, format, outdir)
      execute "#{BPL::Derivatives.libreoffice_path} --invisible --headless --convert-to #{format} --outdir #{outdir} #{Shellwords.escape(path)}"
    end

    # Converts the document to the format specified in the directives hash.
    # TODO: file_suffix and options are passed from ShellBasedProcessor.process but are not needed.
    #       A refactor could simplify this.
    def encode_file(_file_suffix, _options = {})
      convert_to_format
    ensure
      FileUtils.rm_f(converted_file)
    end

    private

      # For jpeg files, a pdf is created from the original source and then passed to the Image processor class
      # so we can get a better conversion with resizing options. Otherwise, the ::encode method is used.
      def convert_to_format
        if directives.fetch(:format) == "jpg"
          BPL::Derivatives::Processors::Image.new(converted_file, directives).process
        else
          finalize_derivative_output(File.read(converted_file))
        end
      end

      def converted_file
        @converted_file ||= if directives.fetch(:format) == "jpg"
                              convert_to("pdf")
                            else
                              convert_to(directives.fetch(:format))
                            end
      end

      def convert_to(format)
        self.class.encode(source_path, format, BPL::Derivatives.temp_file_base)
        File.join(BPL::Derivatives.temp_file_base, [File.basename(source_path, ".*"), format].join('.'))
      end
  end
end
