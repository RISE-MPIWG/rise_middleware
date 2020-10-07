module LinksHelper
  def icon_link_to(body, url, icon, html_options = {})
    html_options[:class] = '' unless html_options[:class].present?
    html_options[:class] += ' float-right mr-2 btn button btn-sm'
    link_to url, html_options do
      concat content_tag(:i, '', class: "fa fa-#{icon}")
      concat ' '
      concat body
    end
  end

  def medium_icon_link_to(body, url, icon, html_options = {})
    html_options[:class] = '' unless html_options[:class].present?
    html_options[:class] += ' btn btn-default'
    link_to url, html_options do
      concat content_tag(:i, '', class: "fas fa-#{icon}")
      concat ' '
      concat body
    end
  end

  def view_link_to(resource, object = nil)
    power = Power.new(current_user)
    if object
      path = [object, resource]
      if object.is_a?(Collection)
        path = [:admin, object, resource]
      end
    else
      path = resource
    end
    if (power && power.readable_resource?(resource)) || resource.public_access?
      link_to "#{icon 'fas', 'book'} #{resource}".html_safe, path, data: { turbolinks: false }
    else
      resource.to_s
    end
  end

  def modal_link_to(body, url)
    link_to url, data: { toggle: 'modal', target: '#modal', turbolinks: false , remote: true }, class: 'modal-link' do
      concat body
    end
  end

  def large_modal_link_to(body, url)
    link_to url, data: { toggle: 'modal', target: '#modal-large', turbolinks: false, id: body[:id] }, class: 'modal-link' do
      concat body
    end
  end

  def small_button_to(body, url, icon, html_options = {})
    html_options[:class] = '' unless html_options[:class].present?
    html_options[:class] += 'button btn btn-block btn-link mr-2'
    link_to url, html_options do
      concat content_tag(:i, '', class: "fas fa-#{icon}")
      concat ' '
      concat body
    end
  end

  def small_button_outline_to(body, url, icon, html_options = {})
    html_options[:class] = '' unless html_options[:class].present?
    html_options[:class] += ' button btn btn-block btn-link mr-2'
    link_to url, html_options do
      concat content_tag(:i, '', class: "far fa-#{icon}")
      concat ' '
      concat body
    end
  end
end
