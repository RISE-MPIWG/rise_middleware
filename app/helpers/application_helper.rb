module ApplicationHelper
  BOOTSTRAP_CLASSES = {
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-warning',
    notice: 'alert-info'
  }.freeze

  # Returns an array of the possible key/i18n values for the enum
  # Example usage:
  # enum_options_for_select(User, :approval_state)
  def enum_options_for_select(class_name, enum)
    class_name.send(enum.to_s.pluralize).map do |key, _|
      [enum_i18n(class_name, enum, key), key]
    end
  end

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = 'info' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

  # Returns the i18n version the the models current enum key
  # Example usage:
  # enum_l(user, :approval_state)
  def enum_l(model, enum)
    enum_i18n(model.class, enum, model.send(enum))
  end

  # Returns the i18n string for the enum key
  # Example usage:
  # enum_i18n(User, :approval_state, :unprocessed)
  def enum_i18n(class_name, enum, key)
    I18n.t("activerecord.attributes.#{class_name.model_name.i18n_key}.#{enum.to_s.pluralize}.#{key}")
  end

  def flash_messages
    capture do
      flash.each do |type, message|
        klass = BOOTSTRAP_CLASSES[type.to_sym] || type
        concat content_tag :div, message, class: "alert #{klass}"
      end
    end
  end

  # see devise_error_messages!
  def errors_for(resource)
    errors = resource.errors
    return '' if errors.empty?

    sentence = t 'errors.messages.not_saved',
                 count: errors.count,
                 resource: resource.model_name.singular
    messages = errors.full_messages.map { |msg| content_tag :li, msg }
    content_tag :div,
                safe_join([content_tag(:h5, sentence),
                           content_tag(:ul, safe_join(messages))]),
                class: 'alert alert-danger alert-block'
  end
end
