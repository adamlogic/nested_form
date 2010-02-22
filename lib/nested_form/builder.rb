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
      @template.after_nested_form do
        model_object = object.class.reflect_on_association(association).klass.new
        @template.concat(%Q[<div id="#{association}_fields_blueprint" style="display: none">])
        fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
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
      hidden_field(:_destroy) + @template.link_to(name, "#", :class => "remove_nested_fields")
    end

    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      @fields[association] = block
      super
    end


    def fields_for_nested_model(name, association, args, block)
      @template.concat('<div class="fields">')
      super
      @template.concat('</div>')
    end
  end
end
