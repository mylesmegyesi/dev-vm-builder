require 'thor'
require 'dev_vm_builder/vm_config'
require 'dev_vm_builder/build_vm'
require 'dev_vm_builder/generate_vagrant_template'

module DevVmBuilder
  class Cli < Thor
    package_name 'dev-vm-builder'

    def self.vm_cmd_options

      method_option 'name', {
        :aliases => '-n',
        :default => '{{output directory}}',
        :desc    => 'The disk size in megabytes to give the virtual machine',
        :type    => :string
      }

      method_option :username, {
        :aliases => '-u',
        :default => 'vagrant',
        :desc    => 'The username for the admin user',
        :type    => :string
      }

      method_option :password, {
        :aliases => '-p',
        :default => 'vagrant',
        :desc    => 'The password for the admin user',
        :type    => :string
      }

      method_option :home, {
        :type    => :string,
        :aliases => '-h',
        :default => '/home/{{username}}/',
        :desc    => 'The home directory for the admin user'
      }

      method_option :memory, {
        :aliases => '-m',
        :default => 4096,
        :desc    => 'The amount of memory in megabytes to give the virtual machine',
        :type    => :numeric
      }

      method_option :cpus, {
        :aliases => '-c',
        :default => 4,
        :desc    => 'The number of virtual cpus to give the virtual machine',
        :type    => :numeric
      }

      method_option 'disk-size', {
        :aliases => '-d',
        :default => 20140,
        :desc    => 'The disk size in megabytes to give the virtual machine',
        :type    => :numeric
      }

      builders = DevVmBuilder::Builders.builders(DevVmBuilder::ISOS, VmConfig.new('tmp', {})).map { |b| b[:name] }

      method_option 'builder', {
        :type    => :string,
        :aliases => '-b',
        :default => builders.first,
        :desc    => 'The builder to create the virtual machine with',
        :enum    => builders
      }

    end

    desc 'build OUTPUT_DIRECTORY', 'Build a virtual machine (.box file)'
    vm_cmd_options

    def build(output_dir=nil)
      BuildVm.new(vm_config(output_dir)).call
    end

    desc 'generate OUTPUT_DIRECTORY', 'Generate a Vagrant development VM'
    vm_cmd_options

    def generate(output_dir=nil)
      GenerateVagrantTemplate.new(vm_config(output_dir)).call
    end

    desc 'new OUTPUT_DIRECTORY', 'Generate a Vagrant development VM and build a VM (.box file)'
    vm_cmd_options

    def new(output_dir=nil)
      config = vm_config(output_dir)
      GenerateVagrantTemplate.new(config).call
      BuildVm.new(config).call
    end

    private

    def vm_config(output_dir)
      output = output_dir || File.join(Dir.pwd, 'dev-vm')
      home = options[:home] == '/home/{{username}}/' ? "/home/#{options[:username]}" : options[:home]
      name = options[:name] == '{{output directory}}' ? File.basename(output) : options[:name]
      VmConfig.new(temp_directory, {
        :admin_username => options[:username],
        :admin_password => options[:password],
        :home           => home,
        :memory         => options[:memory],
        :cpus           => options[:cpus],
        :disk_size      => options[:'disk-size'],
        :builder        => options[:builder],
        :name           => name,
        :output         => output
      })
    end

    def temp_directory
      Dir.mktmpdir('packer') { |dir| dir }
    end

  end
end
