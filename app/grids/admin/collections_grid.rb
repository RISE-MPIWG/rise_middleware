module Admin
  class CollectionsGrid
    include Datagrid

    attr_accessor :current_power

    def initialize(page, attributes = {})
      super(attributes)
      @current_power = attributes['current_power']
      if @current_power
        scope do
          @current_power.updatable_collections.page(page).per(20)
        end
      end
    end

    scope do
      Collection.none
    end

    filter :name, header: "Search" do |value|
      where("name ilike '%#{value}%'")
    end

    column(:name, header: Collection.human_attribute_name('name'), class: 'w-25') do |asset|
      format(asset.name) do |_value|
        modal_link_to "#{icon 'fas', 'books'} #{asset.name}".html_safe, asset
      end
    end

    column(:organisation, header: I18n.t('provider'), class: 'w-16 d-none d-sm-table-cell') do |asset|
      format(asset.organisation) do |_value|
        modal_link_to "#{icon 'fas', 'university'} #{asset.organisation}".html_safe, asset.organisation
      end
    end

    column(:number_of_resources, header: I18n.t('number_of_resources'), class: 'w-16  d-none d-sm-table-cell') do |asset|
      format(asset) do |_value|
        asset.resources.size
      end
    end

    column(:actions, header: I18n.t('actions'), class: 'w-8') do |asset|
      format(asset) do |_value|
        content_tag('div') do
          if current_power.updatable_collection?(asset)
            concat small_button_to I18n.t('action.manage'), admin_collection_resources_path(asset), 'cog'
          end
          if current_power.destroyable_collection?(asset)
            concat small_button_to I18n.t('action.archive'), [:admin, asset], 'archive', method: :delete, data: { confirm: t('are_you_sure') }
          end
        end
      end
    end
  end
end
