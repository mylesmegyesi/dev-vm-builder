require 'dev_vm_builder/isos'
require 'dev_vm_builder/builders'
require 'dev_vm_builder/render_template_file'

module DevVmBuilder
  class BuildVm

    PACKER_TEMPLATE_ROOT = File.expand_path(File.join('..', '..', '..', 'packer_template'), __FILE__)

    def initialize(vm_config)
      @vm_config = vm_config
    end

    def call
      generate_packer_template
      generate_preseed
      generate_postinstall
      packer_build
    end

    private

    attr_reader :vm_config

    def packer_build
      exec "cd #{vm_config.output} && packer build --force=true --only=#{vm_config.builder} #{vm_config.compiled_packer_template_path}"
    end

    def generate_packer_template
      render_packer_template_file('template.json.erb', vm_config.compiled_packer_template_path)
    end

    def generate_preseed
      render_packer_template_file('preseed/preseed.cfg.erb', vm_config.compiled_preseed_path)
    end

    def generate_postinstall
      render_packer_template_file('scripts/postinstall.sh.erb', vm_config.compiled_postinstall_script_path)
    end

    def render_packer_template_file(packer_template_file_path, output)
      full_path = File.join(PACKER_TEMPLATE_ROOT, packer_template_file_path)
      RenderTemplateFile.new(full_path, output, binding).call
    end

  end
end
