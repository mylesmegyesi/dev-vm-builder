module DevVmBuilder
  class PackerConfig

    def initialize(temp_directory)
      @temp_directory = temp_directory
    end

    def packer_template
      File.join(temp_directory, 'template.json')
    end

    def preseed_dir
      File.join(temp_directory, 'preseed')
    end

    def preseed
      File.join(temp_directory, 'preseed', 'preseed.cfg')
    end

    def postinstall_script
      File.join(temp_directory, 'scripts', 'postinstall.sh')
    end

    private

    attr_reader :temp_directory

  end
end
