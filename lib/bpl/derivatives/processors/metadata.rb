require 'hydra-file_characterization'

module BPL::Derivatives::Processors
  class Metadata < Processor

    def process
      return unless object.has_content?
      out_xml = Hydra::FileCharacterization.characterize(object.content, object.filename_for_characterization.join(""), :fits) do |config|
        config[:fits] = BPL::Derivatives.config.fits_path
      end
    end
  end
end
