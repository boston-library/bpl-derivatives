module BPL::Derivatives
  class PersistFileSystemOutputService < PersistOutputFileService
    def self.call(object, directives)
      filename = determine_original_name(object.content)
      write_file(object.content, directives, filename)
    end

    # @param file [Hydra::Derivatives::IoDecorator]
    def self.determine_original_name(file)
      if file.respond_to? :original_filename
        file.original_filename
      else
        "derivative"
      end
    end

    def self.write_file(content, directives, filename)
      path = directives.fetch(:path)
      fmt = directives.fetch(:format)
      full_file_name = File.join(path, "#{filename}.#{fmt}")
      raise ArgumentError, "path directive is blank" if path.blank?
      raise ArgumentError, "format directive is blank" if fmt.blank?
      File.open(full_file_name, "w+") do |f|
        f.write(content)
      end
    end
    private_class_method :write_file


  end
end
