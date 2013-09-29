require 'json'
require 'erb'
require 'fileutils'

module DevVmBuilder
  class RenderTemplateFile

    def initialize(input_absolute_path, output_absolute_path, _binding)
      @input_absolute_path  = input_absolute_path
      @output_absolute_path = output_absolute_path
      @_binding             = _binding
    end

    def call
      template_contents = File.open(input_absolute_path).read
      rendered = ERB.new(template_contents).result(_binding)
      FileUtils.mkpath(File.dirname(output_absolute_path))
      File.open(output_absolute_path, 'w') {|f| f.write(rendered)}
    end

    private

    attr_reader :input_absolute_path, :output_absolute_path, :_binding

  end
end
