class ResearchToolsGrid
  include Datagrid

  attr_accessor :current_power

  def initialize(page, attributes = {})
    super(attributes)
    @current_power = attributes['current_power']
    if @current_power
      scope do
        @current_power.research_tools.page(page).per(20)
      end
    end
  end

  scope do
    ResearchTool.none
  end

  filter :name, header: "Name (contains)" do |value|
    complete_search value
  end
  column(:name, header: ResearchTool.human_attribute_name('name'), class: 'w-25') do |asset|
    format(asset.name) do |_value|
      modal_link_to "#{icon 'fas', 'wrench'} #{asset}".html_safe, asset
    end
  end

  column(:description, header: ResearchTool.human_attribute_name('description'), class: 'w-8') do |asset|
    format(asset.description) do |_value|
      _value
    end
  end
end
