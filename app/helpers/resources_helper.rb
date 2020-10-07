module ResourcesHelper
  def display_access_right_to(model)
    access_right = if current_user.present?
                     current_user.access_right_for_model(model)
                   else
                     if model.public_access?
                       :public_access
                     else
                       OrganisationCollection.access_rights.first.first
                     end
                   end
    enum_i18n(OrganisationCollection, :access_right, access_right)
  end

  def display_access_right_label_to(model)
    access_right = if current_user.present?
                     current_user.access_right_for_model(model)
                   else
                     if model.public_access?
                       :public_access
                     else
                       OrganisationCollection.access_rights.first.first
                     end
                   end
    case access_right
    when :public_access, :read
      label_class = 'success'
      icon = 'unlock'
    else
      label_class = 'danger'
      icon = 'lock'
    end
    content_tag(:span, nil, class: "badge badge-#{label_class}") do
      concat content_tag(:i, nil, class: "fa fa-#{icon}")
      concat ' '
      concat enum_i18n(OrganisationCollection, :access_right, access_right)
    end
  end

  def display_corpus_button(resource, corpus)
    if current_user
      if corpus.corpus_resources.map(&:resource_id).include? resource.id
        small_button_to '', [:remove, corpus, resource], 'star', remote: true, class: 'add-to-corpus button btn btn-xs btn-default', id: "add-to-corpus-#{resource.id}"
      else
        small_button_outline_to '', [:add, corpus, resource], 'star', remote: true, class: 'add-to-corpus button btn btn-xs btn-default', id: "add-to-corpus-#{resource.id}"
      end
    end
  end

  def display_tags(resource)
    o = ""
    resource.tags_from(current_user).to_a.each do |tag|
      o += content_tag(:span, tag, class: "label label-info margin-right-5")
    end
    o.html_safe
  end

  def display_metadata(resource)
    return unless resource.cascading_metadata
    to_display = resource.cascading_metadata.reject { |m| Resource::METADATA_FIELDS_TO_IGNORE_FOR_DISPLAY.include?(m) }
    content_tag(:pre) do
      resource.cascading_metadata.to_yaml
    end
  end

  def resource_sections_for_tree_display(resource)
    sections_as_array = []
    if resource.sections.empty?
      resource.pull_sections(current_user)
    end
    resource.sections.each do |section|
      opened = false
      parent_uuid = '#'
      icon = 'fa fa-book'
      if section.parent.present?
        parent_uuid = section.parent.uuid
        icon = 'fa fa-folder-o'
      else
        opened = true
      end
      if section.children.empty?
        icon = 'fa fa-file-text-o'
      end
      sections_as_array << { id: section.uuid, parent: parent_uuid, text: section.title, state: { opened: opened }, icon: icon }
    end
    sections_as_array.to_json.html_safe
  end

  def format_json_attribute(attribute)
    attribute = attribute.slice(0, 1).capitalize + attribute.slice(1..-1)
    attribute.scan(/[A-Z][a-z]+/).join(' ').capitalize
  end
end
