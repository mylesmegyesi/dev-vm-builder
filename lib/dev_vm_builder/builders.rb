module DevVmBuilder
  module Builders

    def self.base_builder_config(vm_config)
      {
        :boot_command => [
          "<esc><esc><enter><wait>",
          "/install/vmlinuz noapic preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
          "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
          "hostname={{ .Name }} ",
          "fb=false debconf/frontend=noninteractive ",
          "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA keyboard-configuration/variant=USA console-setup/ask_detect=false ",
          "initrd=/install/initrd.gz -- <enter>"
        ],
        :boot_wait         => '5s',
        :disk_size         => vm_config.disk_size,
        :headless          => true,
        :http_directory    => vm_config.compiled_preseed_directory_path,
        :shutdown_command   => "echo '#{vm_config.admin_password}' | sudo -S shutdown -P now",
        :ssh_password       => vm_config.admin_password,
        :ssh_port           => 22,
        :ssh_username       => vm_config.admin_username,
        :ssh_wait_timeout   => '20m'
      }
    end

    def self.iso_config(iso)
      {
        :iso_checksum      => iso[:checksum],
        :iso_checksum_type => iso[:checksum_type],
        :iso_urls          => iso[:urls]
      }
    end

    def self.virtualbox_builder(iso, vm_config)
      {
        :name => "#{iso[:name]}.virtualbox",
        :type => 'virtualbox-iso',
        :guest_os_type => 'Ubuntu_64',
        :vboxmanage => [
          [
            'modifyvm',
            '{{.Name}}',
            '--memory',
            vm_config.memory.to_s
          ],
          [
            'modifyvm',
            '{{.Name}}',
            '--cpus',
            vm_config.cpus.to_s
          ]
        ]
      }
    end

    def self.vmware_builder(iso, vm_config)
      {
        :name                => "#{iso[:name]}.vmware",
        :type                => 'vmware-iso',
        :guest_os_type       => 'ubuntu-64',
        :tools_upload_flavor => 'linux',
        :tools_upload_path   => File.join(vm_config.home, 'VMWareTools.iso'),
        :vmx_data => {
          :'cpuid.coresPerSocket' => '1',
          :memsize                => vm_config.memory.to_s,
          :numvcpus               => vm_config.cpus.to_s
        }
      }
    end

    def self.builder(provider, iso, vm_config)
      self.send("#{provider}_builder", iso, vm_config).
        merge(base_builder_config(vm_config)).
        merge(iso_config(iso))
    end

    def self.builders(isos, vm_config)
      isos.reduce([]) do |acc, iso|
        acc << builder(:virtualbox, iso, vm_config)
        acc << builder(:vmware, iso, vm_config)
        acc
      end
    end

    def self.provisioners(builders, vm_config)
      builders.reduce({}) do |acc, builder|
        acc[builder[:name]] = {
          :execute_command => "echo '#{vm_config.admin_password}'|sudo -S sh '{{.Path}}'"
        }
        acc
      end
    end

  end
end
