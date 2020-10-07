class CorporaGrid
  include Datagrid

  attr_accessor :current_power

  def initialize(page, attributes = {})
    super(attributes)
    @current_power = attributes['current_power']
    if @current_power
      scope do
        @current_power.corpora.page(page).per(20)
      end
    end
  end

  scope do
    Corpus.none
  end

  filter :name, header: "Search" do |value|
    where("name ilike '%#{value}%'")
  end

  column(:name, header: Corpus.human_attribute_name('name'), class: 'w-25') do |asset|
    format(asset.name) do |_value|
      modal_link_to asset, asset
    end
  end

  column(:description, header: Corpus.human_attribute_name('description'), class: 'w-16') do |asset|
    format(asset.name) do |_value|
      modal_link_to asset, asset
    end
  end

  column(:actions, header: I18n.t('actions'), class: 'w-8') do |asset|
    format(asset) do |_value|
      content_tag('div') do
        if current_power.updatable_corpus?(asset)
          concat small_button_to I18n.t('action.manage'), corpus_resources_path(asset), 'cog'
        end
        if current_power.destroyable_corpus?(asset)
          concat small_button_to I18n.t('action.archive'), asset, 'archive', method: :delete, data: { confirm: t('are_you_sure') }
        end
      end
    end
  end
end
