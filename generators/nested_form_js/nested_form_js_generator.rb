class NestedFormJsGenerator < Rails::Generator::Base
  default_options :framework => 'jquery'

  def add_options!(opt)
    frameworks = [:jquery]
    opt.on('-w', '--framework FRAMEWORK', frameworks,
           'Specify framework for generated js',
           "  Supported frameworks: #{frameworks.join(', ')}",
           "  Default: #{options[:framework]}") do |value|
      options[:framework] = value
    end
  end

  def manifest
    record do |m|
      m.file "#{options[:framework]}.js", 'public/javascripts/nested_form.js'
    end
  end
end
