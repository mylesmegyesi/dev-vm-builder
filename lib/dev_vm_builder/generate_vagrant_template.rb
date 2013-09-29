require 'active_support/core_ext/string'

module DevVmBuilder
  class GenerateVagrantTemplate

    VAGRANT_TEMPLATE_ROOT = File.expand_path('../../../vagrant_template', __FILE__)

    def initialize(vm_config, output)
      @vm_config = vm_config
      @output    = output
    end

    def call
      vm_name
      role_name
      render_vagrant_template_file('Vagrantfile.erb', 'Vagrantfile')
      render_vagrant_template_file('roles/vm.rb.erb', "roles/#{role_name}.rb")
      render_vagrant_template_file('Cheffile.erb', 'Cheffile')
      render_vagrant_template_file('.gitignore.erb', '.gitignore')
    end

    private

    attr_reader :vm_config, :output

    def write_vagrantfile
    end

    def render_vagrant_template_file(vagrant_template_file_path, output_file)
      input_absolute_path = File.join(VAGRANT_TEMPLATE_ROOT, vagrant_template_file_path)
      output_absolute_path = File.join(output, output_file)
      RenderTemplateFile.new(input_absolute_path, output_absolute_path, binding).call
    end

    def vm_name
      @vm_name ||= File.basename(output)
    end

    def role_name
      @role_name ||= ActiveSupport::Inflector.underscore(vm_name)
    end

  end
end
