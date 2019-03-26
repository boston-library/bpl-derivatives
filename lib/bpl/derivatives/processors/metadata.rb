require 'hydra-file_characterization'

module BPL::Derivatives::Processors
  class Metadata < Processor
    attr_reader :content, :filename_for_characterization

    def initialize(content, directives, opts = {})
      self.content = content
      self.filename_for_characterization = opts.fetch(:filename_for_characterization)
    end

    def process
      return unless content.has_content?
      Hydra::FileCharacterization.characterize(content, filename_for_characterization.join(""), :fits) do |config|
        config[:fits] = BPL::Derivatives.config.fits_path
      end
    end
  end
end
