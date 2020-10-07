module Admin
  class ResearchToolsGrid
    include Datagrid

    attr_accessor :current_power

    def initialize(page, attributes = {})
      super(attributes)
      @current_power = attributes['current_power']
      if @current_power
        scope do
          @current_power.updatable_research_tools.page(page).per(20)
        end
      end
    end

    scope do
      ResearchTool.none
    end

    filter :name, header: "Search" do |value|
      where("name ilike '%#{value}%'")
    end

    column(:name, header: ResearchTool.human_attribute_name('name'), class: 'w-25') do |asset|
      format(asset.name) do |_value|
        modal_link_to "#{icon 'fas', 'wrench'} #{asset}".html_safe, asset
      end
    end

    column(:description, header: ResearchTool.human_attribute_name('description'), class: 'w-16 d-none d-sm-table-cell') do |asset|
      format(asset.description) do |_value|
        truncate(asset.description)
      end
    end

    column(:enabled_organisations, header: I18n.t('enabled', model: Organisation.model_name.human(count: 2)), class: 'w-16 d-none d-sm-table-cell') do |asset|
      format(asset) do |_value|
        asset.enabled_organisations.join(', ')
      end
    end

    column(:actions, header: I18n.t('actions'), class: 'w-8') do |asset|
      format(asset) do |_value|
        content_tag('div') do
          if current_power.updatable_research_tool?(asset)
            concat small_button_to I18n.t('action.manage'), manage_access_admin_research_tool_path(asset), 'cog'
          end
          if current_power.destroyable_research_tool?(asset)
            concat small_button_to I18n.t('action.archive'), [:admin, asset], 'archive', method: :delete, data: { confirm: t('are_you_sure') }
          end
        end
      end
    end
  end
end
