class ResourcesGrid
  include Datagrid

  attr_accessor :current_power, :corpus

  def initialize(page, attributes = {})
    super(attributes)
    @current_power = attributes['current_power']
    @corpus = attributes['corpus']
    if @current_power
      scope do
        @current_power.resources.page(page).per(20)
      end
    end
  end

  scope do
    Resource.none
  end

  filter :name, header: "Search by Name" do |value|
    where("name ilike ?","%#{sanitize_sql_like(value.strip)}%")
  end

  filter :author, header: "Search by Creator" do |value|
    where("metadata -> 'dublincore' ->> :key ILIKE :value", key: "creator", value: "%#{sanitize_sql_like(value.strip)}%")
  end

  filter :metadata, header: "Search by Any Metadata Field" do |value|
    where('metadata::text ILIKE ?', "%#{value}%")
  end

  filter :language, :enum, include_blank: I18n.t('all_filter', model: 'Languages'), select: proc { Resource::LANGUAGES } do |value|
    where("metadata -> 'dublincore' @> ?", { language: value }.to_json)
  end

  filter(:collection_id, :enum, include_blank: I18n.t('all_filter', model: Collection.model_name.human(count: 2)), select: proc { Collection.all.map { |c| [c.name, c.id] } })

  column(:name, header: Resource.human_attribute_name('name'), class: 'w-25') do |asset|
    format(asset.name) do |_value|
      view_link_to asset
    end
  end

  column(:author, header: Resource.human_attribute_name('author'), class: 'w-16 d-none d-sm-table-cell') do |asset|
    if asset.metadata
      format(asset.metadata['author']) do |value|
        value
      end
    end
  end

  column(:collection, header: Collection.model_name.human, class: 'w-25  d-none d-sm-table-cell') do |asset|
    format(asset.collection) do |_value|
      @collection = asset.collection
      modal_link_to "#{icon 'fas', 'books'} #{@collection}".html_safe, @collection
    end
  end

  column(:organisation, header: I18n.t('provider'), class: 'w-8  d-none d-sm-table-cell') do |asset|
    format(asset.collection.organisation) do |_value|
      modal_link_to "#{icon 'fas', 'university'} #{asset.collection.organisation}".html_safe, asset.collection.organisation
    end
  end

    column(:access_right, header: I18n.t('access_right'), class: 'w-8 d-none d-sm-table-cell') do |asset|
      format(asset.organisation) do |_value|
        display_access_right_to(asset)
      end
    end

    column(:actions, header: I18n.t('actions'), class: 'w-8 d-none d-sm-table-cell') do |asset|
      format(asset) do |_value|
        content_tag('div') do
          concat display_corpus_button(asset, @corpus)
        end
      end
    end
end
