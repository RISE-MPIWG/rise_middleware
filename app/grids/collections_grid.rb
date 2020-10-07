class CollectionsGrid
  include Datagrid

  attr_accessor :current_power

  def initialize(page, attributes = {})
    super(attributes)
    @current_power = attributes['current_power']
    if @current_power
      scope do
        @current_power.collections.page(page).per(20)
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
      modal_link_to "#{icon 'fas', 'books'} #{asset}".html_safe, asset
    end
  end

  column(:organisation, header: I18n.t('provider'), class: 'w-16') do |asset|
    format(asset.organisation) do |_value|
      modal_link_to "#{icon 'fas', 'university'} #{asset.organisation}".html_safe, asset.organisation
    end
  end

  column(:number_of_resources, header: I18n.t('number_of_resources'), class: 'w-16') do |asset|
    format(asset) do |_value|
      asset.resources.size
    end
  end

  column(:access_right, header: I18n.t('access_right'), class: 'w-8') do |asset|
    format(asset.organisation) do |_value|
      display_access_right_to(asset)
    end
  end
end
