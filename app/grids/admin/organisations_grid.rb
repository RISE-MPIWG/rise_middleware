module Admin
  class OrganisationsGrid
    include Datagrid
    attr_accessor :current_power

    def initialize(page, attributes = {})
      super(attributes)
      @current_power = attributes['current_power']
      if @current_power
        scope do
          @current_power.updatable_organisations.page(page).per(20)
        end
      end
    end
    scope do
      Organisation.none
    end

    filter :name, header: "Search" do |value|
      where("name ilike '%#{value}%'")
    end
    column(:name, header: Organisation.human_attribute_name('name'), class: 'w-25') do |asset|
      format(asset.name) do |_value|
        modal_link_to "#{icon 'fas', 'university'} #{asset}".html_safe, asset
      end
    end

    column(:slug, header: Organisation.human_attribute_name('slug'), class: 'w-16 d-none d-sm-table-cell') do |asset|
      format(asset.slug) do |_value|
        asset.slug
      end
    end

    column(:actions, header: I18n.t('actions'), class: 'w-8') do |asset|
      format(asset) do |_value|
        content_tag('div') do
          if current_power.updatable_organisation?(asset)
            concat small_button_to t('action.edit'), edit_admin_organisation_path(asset), 'edit'
          end
          if current_power.destroyable_organisation?(asset)
            concat small_button_to I18n.t('action.archive'), [:admin, asset], 'archive', method: :delete, data: { confirm: t('are_you_sure') }
          end
        end
      end
    end
  end
end
