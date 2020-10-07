module Admin
  module Collections
    class ResourcesGrid
      include Datagrid

      attr_accessor :current_power
      attr_accessor :collection

      def initialize(page, attributes = {})
        super(attributes)
        @current_power = attributes['current_power']
        @collection    = attributes['collection']
        if @current_power
          scope do
            @collection.resources.page(page).per(20)
          end
        end
      end

      scope do
        Resource.none
      end

      filter :name, header: "Search" do |value|
        where("name ilike '%#{value}%'")
      end

      column(:name, header: Resource.human_attribute_name('name'), class: 'w-25') do |asset|
        format(asset.name) do |_value|
          view_link_to asset, asset.collection
        end
      end

      column(:uri, header: Resource.human_attribute_name('uri'), class: 'w-16 d-none d-sm-table-cell') do |asset|
        format(asset.uri) do |_value|
          link_to asset.uri, asset.uri, target: '_blank'
        end
      end

      column(:actions, header: I18n.t('actions'), class: 'w-8') do |asset|
        format(asset) do |_value|
          content_tag('div') do
            # TODO: add power to remove a resource
            if true
              # if asset.sections.empty?
              #   concat small_button_to I18n.t('action.pull_full_text'), [:pull_full_text, :admin, @collection, asset], 'arrow-down', remote: true, class: 'button btn btn-xs btn-default pull-btn'
              # end
              concat small_button_to I18n.t('action.remove'), [:admin, @collection, asset], 'times', method: :delete, data: { confirm: t('are_you_sure') }, class: 'button btn btn-xs btn-default'
              concat content_tag('i', '', class: 'fa fa-circle-o-notch fa-spin fa-fw', style: 'display:none')
            end
          end
        end
      end
    end
  end
end
