module Admin
  module Collections
    class OrganisationsGrid
      include Datagrid

      attr_accessor :current_power
      attr_accessor :collection

      def initialize(page, attributes = {})
        super(attributes)
        @current_power = attributes['current_power']
        @collection    = attributes['collection']
        if @current_power
          scope do
            @current_power.organisations.skip_organisation(@collection.organisation).page(page).per(20)
          end
        end
      end

      scope do
        Organisation.none
      end

      filter :name, header: "Name (contains)" do |value|
        search_by_name value
      end

      column(:name, header: Organisation.human_attribute_name('name'), class: 'w-25') do |asset|
        format(asset.name) do |_value|
          modal_link_to asset, asset
        end
      end

      column(:slug, header: Organisation.human_attribute_name('access_right'), class: 'w-16 d-none d-sm-table-cell') do |asset|
        format(asset.slug) do |_value|
          asset.access_right_for_collection(@collection)
        end
      end

      column(:access, header: '', class: 'w-8') do |asset|
        format(asset) do |_value|
          # form_for :organisation_access, url: [:set_access, :admin, @collection, asset], method: :put, remote: true do |f|
          #   concat f.select :access_right, options_for_select(enum_options_for_select(OrganisationCollection, :access_right), organisation_access_for_collection(asset, @collection))
          #   concat ' '
          #   concat content_tag('i', '', class: 'fa fa-circle-o-notch fa-spin fa-fw', style: 'display:none')
          # end
          content_tag('div', class: 'btn-group-vertical btn-block') do
            if true
              concat small_button_to I18n.t('action.manage'), edit_admin_collection_organisation_path(@collection, asset), 'cog'
            end
          end
        end
      end
    end
  end
end
