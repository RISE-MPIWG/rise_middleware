module Corpora
  class AddResourcesGrid
    include Datagrid

    attr_accessor :current_power
    attr_accessor :corpus

    def initialize(page, attributes = {})
      super(attributes)
      @current_power = attributes['current_power']
      @corpus = attributes['corpus']
      if @current_power
        scope do
          @corpus.addable_resources.page(page).per(20)
        end
      end
    end

    scope do
      Resource.none
    end

    filter :name, header: "Search by Name" do |value|
      where("name ilike '%#{value.strip}%'")
    end

    filter :creator, header: "Search by Creator" do |value|
      where("metadata -> 'dublincore' ->> :key ILIKE :value", key: "creator", value: "%#{value.strip}%")
    end

    filter :metadata, header: "Search by Any Metadata Field" do |value|
      by_any_metadata_field(value.strip)
    end

    filter :language, :enum, include_blank: I18n.t('all_filter', model: 'Languages'), select: proc { Resource::LANGUAGES } do |value|
      where('metadata @> ?', { language: value }.to_json)
    end

    filter(:collection_id, :enum, include_blank: I18n.t('all_filter', model: Collection.model_name.human(count: 2)), select: proc { Collection.all.map { |c| [c.name, c.id] } })
    column(:name, header: Resource.human_attribute_name('name'), class: 'w-8') do |asset|
      format(asset.name) do |_value|
        link_to asset, asset, data: { turbolinks: false }
      end
    end

    column(:collection, header: Collection.model_name.human, class: 'w-25') do |asset|
      format(asset.collection) do |_value|
        @collection = asset.collection
        modal_link_to @collection, @collection
      end
    end

    column(:uri, header: Resource.human_attribute_name('uri'), class: 'w-8') do |asset|
      format(asset.uri) do |_value|
        link_to asset.uri, "http://" + asset.uri, target: '_blank'
      end
    end

    column(:actions, header: I18n.t('actions'), class: 'col-md-1') do |asset|
      format(asset) do |_value|
        content_tag('div') do
          # TODO: add power to remove a resource
          if @corpus.resources.include? asset
            concat small_button_to I18n.t('action.remove'), [@corpus, asset], 'times', method: :delete, data: { confirm: t('are_you_sure') }, class: 'button btn btn-xs btn-default'
          else
            concat small_button_to I18n.t('action.add_to_corpus'), [:add, @corpus, asset], 'plus', method: :put, remote: true, class: 'button btn btn-xs btn-success'
          end
        end
      end
    end
  end
end
