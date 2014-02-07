module DevVmBuilder
  class VmConfig

    attr_reader :admin_username, :admin_password, :home,
      :memory, :cpus, :disk_size, :builder, :name, :output

    def initialize(temp_directory, options)
      @temp_directory = temp_directory
      @admin_username = options[:admin_username]
      @admin_password = options[:admin_password]
      @home           = options[:home] || ''
      @memory         = options[:memory]
      @cpus           = options[:cpus]
      @disk_size      = options[:disk_size]
      @builder        = options[:builder]
      @name           = options[:name]
      @output         = options[:output]
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

    def provider
      builder.split('.').last
    end

    private

    attr_reader :temp_directory

  end
end
