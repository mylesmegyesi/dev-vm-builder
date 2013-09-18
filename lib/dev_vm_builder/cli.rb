require 'thor'
require 'dev_vm_builder/vm_config'
require 'dev_vm_builder/build_vm'

module DevVmBuilder
  class Cli < Thor
    package_name 'dev-vm-builder'

    desc 'build', 'Build a virtual machine (.box file)'

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

    method_option 'vm-name', {
      :aliases => '-v',
      :default => 'dev-vm',
      :desc    => 'The hostname of the virtual machine',
      :type    => :string
    }

    method_option 'provider', {
      :type    => :string,
      :aliases => '-P',
      :default => 'virtualbox',
      :desc    => 'The provider to create the virtual machine for',
      :enum    => %w(virtualbox vmware)
    }

    def build
      BuildVm.new(vm_config).call
    end

    private

    def vm_config
      home = options[:home] == '/home/{{username}}/' ? "/home/#{options[:username]}" : options[:home]
      VmConfig.new(temp_directory, {
        :admin_username => options[:username],
        :admin_password => options[:password],
        :home           => home,
        :memory         => options[:memory],
        :cpus           => options[:cpus],
        :disk_size      => options[:'disk-size'],
        :vm_name        => options[:'vm-name'],
        :provider       => options[:provider]
      })
    end

    def temp_directory
      Dir.mktmpdir('packer') { |dir| dir }
    end

  end
end