class ToolExportsGrid
  include Datagrid

  attr_accessor :current_power

  def initialize(page, attributes = {})
    super(attributes)
    @current_power = attributes['current_power']
    if @current_power
      scope do
        @current_power.tool_exports.page(page).per(20)
      end
    end
  end

  scope do
    ToolExport.none
  end

  filter :name, header: "Search" do |value|
    where("name ilike '%#{value}%'")
  end

  column(:name, header: ToolExport.human_attribute_name('name'), class: 'w-25') do |asset|
    format(asset.name) do |_value|
      link_to asset, asset.file.url, data: { turbolinks: false }
    end
  end
end
