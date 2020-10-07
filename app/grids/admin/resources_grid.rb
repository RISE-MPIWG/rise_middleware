module Admin
  class ResourcesGrid
    include Datagrid
    attr_accessor :current_power
    def initialize(page, attributes = {})
      super(attributes)
      @current_power = attributes['current_power']
      if @current_power
        scope do
          @current_power.updatable_resources.page(page).per(20)
        end
      end
    end
    scope do
      Resource.none
    end

    filter :name, header: "Search" do |value|
      where("name ilike '%#{value}%'")
    end

    filter(:collection_id, :enum, include_blank: I18n.t('all_filter', model: Collection.model_name.human(count: 2)), select: proc { Collection.all.map { |c| [c.name, c.id] } })

    column(:name, header: Resource.human_attribute_name('name'), class: 'w-25') do |asset|
      format(asset.name) do |_value|
        view_link_to asset
      end
    end

    column(:uri, header: Resource.human_attribute_name('uri'), class: 'w-16') do |asset|
      format(asset.uri) do |_value|
        link_to asset.uri.truncate(40), asset.uri, target: '_blank'
      end
    end

    column(:actions, header: I18n.t('actions'), class: 'w-8') do |asset|
      format(asset) do |_value|
        content_tag('div') do
          if current_power.updatable_resource?(asset)
            concat small_button_to t('action.edit'), edit_admin_resource_path(asset), 'edit'
          end
          if current_power.destroyable_resource?(asset)
            concat small_button_to I18n.t('action.archive'), [:admin, asset], 'archive', method: :delete, data: { confirm: t('are_you_sure') }
          end
        end
      end
    end
  end
end
