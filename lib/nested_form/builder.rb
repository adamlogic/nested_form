module NestedForm
  class Builder < ActionView::Helpers::FormBuilder
    # Creates a link tag for adding fields for a new nested item.
    #
    # @param name [optional String] Text for the link. Default is "Add a [singular association name]".
    # @param association [Symbol] Name of association to add nested fields for.
    # @return [String] Generated link HTML.
    def link_to_add(name_or_association, association = nil)
      if name_or_association.is_a? Symbol
        association = name_or_association
        name = "Add a #{association.to_s.singularize.humanize.downcase}"
      else
        name = name_or_association
      end
      @fields ||= {}
      @fields[association] ||= {}
      @template.after_nested_form do
        model_object = object.class.reflect_on_association(association).klass.new
        @template.concat(%Q[<div id="#{association}_fields_blueprint" style="display: none">])
        fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association][:block])
        @template.concat('</div>')
      end
      @template.link_to(name, "#", :class => "add_nested_fields", "data-association" => association)
    end

    # Creates a link for removing nested fields.
    #
    # @param [optional String] Text for the link. Defauld is "Remove".
    # @return [String] Generated link HTML.
    def link_to_remove(name = nil)
      name = "Remove" if name.nil?
      hidden_field(:_destroy, :value => 0) + @template.link_to(name, "#", :class => "remove_nested_fields")
    end

    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      opts = args.last.is_a?(Hash) ? args.last : {}
      wrap = opts.delete(:wrap)
      wrap = true if wrap.nil?

      @fields[association] = {
        :wrap => wrap,
        :prepend => opts.delete(:prepend) || '<div class="fields">',
        :append => opts.delete(:append) || '</div>',
        :block => block
      }
      if args.last.is_a?(Hash)
        args.last[:nested_form_association] = association
      else
        args << {:nested_form_association => association}
      end
      super
    end

    def fields_for_nested_model(name, association, args, block)
      options = @fields[args.last[:nested_form_association]];

      if options[:wrap]
        if options[:prepend].respond_to? :call
          prepend = options[:prepend].call(association)
        else
          prepend = options[:prepend]
        end
        @template.concat(prepend)
      end
      super
      if options[:wrap]
        if options[:append].respond_to? :call
          append = options[:append].call(association)
        else
          append = options[:append]
        end
        @template.concat(append)
      end
    end
  end
end
