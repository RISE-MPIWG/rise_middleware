module Admin
  module ResearchTools
    class OrganisationsGrid
      include Datagrid

      attr_accessor :current_power
      attr_accessor :research_tool

      def initialize(page, attributes = {})
        super(attributes)
        @current_power = attributes['current_power']
        @research_tool = attributes['research_tool']
        if @current_power
          scope do
            @current_power.organisations.page(page).per(20)
          end
        end
      end

      scope do
        Organisation.none
      end

      filter :name, header: "Search" do |value|
        where("name ilike '%#{value}%'")
      end

      column(:name, header: Organisation.human_attribute_name('name'), class: 'w-25') do |asset|
        format(asset.name) do |_value|
          modal_link_to "#{icon 'fas', 'university'} #{asset}".html_safe, asset
        end
      end

      column(:slug, header: Organisation.human_attribute_name('slug'), class: 'w-16') do |asset|
        format(asset.slug) do |_value|
          asset.slug
        end
      end

      column(:access, header: I18n.t('access'), class: 'w-8') do |asset|
        format(asset) do |_value|
          form_for :organisation_access, url: [:set_access, :admin, @research_tool, asset], method: :put, remote: true do |f|
            concat f.select :access_right, options_for_select(enum_options_for_select(OrganisationResearchTool, :access_right), organisation_access_for_research_tool(asset, @research_tool))
            concat ' '
            concat content_tag('i', '', class: 'fa fa-circle-o-notch fa-spin fa-fw', style: 'display:none')
          end
        end
      end
    end
  end
end
