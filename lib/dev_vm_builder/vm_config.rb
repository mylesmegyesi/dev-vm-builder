module DevVmBuilder
  class VmConfig

    attr_reader :admin_username, :admin_password, :home,
      :memory, :cpus, :disk_size, :vm_name, :provider

    def initialize(temp_directory, options)
      @temp_directory = temp_directory
      @admin_username = options[:admin_username]
      @admin_password = options[:admin_password]
      @home           = options[:home]
      @memory         = options[:memory]
      @cpus           = options[:cpus]
      @disk_size      = options[:disk_size]
      @vm_name        = options[:vm_name]
      @provider       = options[:provider]
    end

    def compiled_packer_template_path
      File.join(temp_directory, 'template.json')
    end

    def compiled_preseed_directory_path
      File.join(temp_directory, 'preseed')
    end

    def compiled_preseed_path
      File.join(compiled_preseed_directory_path, 'preseed.cfg')
    end

    def compiled_postinstall_script_path
      File.join(temp_directory, 'scripts', 'postinstall.sh')
    end

    private

    attr_reader :temp_directory

  end
end