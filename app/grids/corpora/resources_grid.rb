module Corpora
  class ResourcesGrid
    include Datagrid

    attr_accessor :current_power
    attr_accessor :corpus

    def initialize(page, attributes = {})
      super(attributes)
      @current_power = attributes['current_power']
      @corpus = attributes['corpus']
      if @current_power
        scope do
          @corpus.resources.includes(:collection).page(page).per(20)
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
        view_link_to asset, @corpus
      end
    end

    column(:tags, header: Resource.human_attribute_name('tags'), class: 'w-16 d-none d-sm-table-cell') do |asset|
      format(asset) do |_value|
        display_tags(asset)
      end
    end

    column(:name, header: Collection.model_name.human, class: 'w-25 d-none d-sm-table-cell') do |asset|
      format(asset.name) do |_value|
        modal_link_to "#{icon 'fas', 'books'} #{asset.collection}".html_safe, asset.collection
      end
    end

    column(:actions, header: I18n.t('actions'), class: 'w-8') do |asset|
      format(asset) do |_value|
        content_tag('div') do
          # TODO: add power to remove a resource
          if asset.sections.empty?
          end
          if true
            concat small_button_to I18n.t('action.remove'), [@corpus, asset], 'times', method: :delete, remote: true, class: 'button btn btn-xs btn-default'
          end
        end
      end
    end
  end
  end
