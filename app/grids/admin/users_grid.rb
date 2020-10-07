module Admin
  class UsersGrid
    include Datagrid
    attr_accessor :current_power

    def initialize(page, attributes = {})
      super(attributes)
      @current_power = attributes['current_power']
      if @current_power
        scope do
          @current_power.updatable_users.page(page).per(20)
        end
      end
    end
    scope do
      User.none
    end

    filter :email, header: "Search" do |value|
      where("email ilike '%#{value}%'")
    end

    column(:email, header: User.human_attribute_name('email'), class: 'w-25') do |asset|
      format(asset.email) do |_value|
        modal_link_to "#{icon 'fas', 'user'} #{asset}".html_safe, [:admin, asset]
      end
    end

    column(:role, header: User.human_attribute_name('role'), class: 'w-16 d-none d-sm-table-cell') do |asset|
      format(asset.role) do |_value|
        enum_i18n(User, :role, asset.role)
      end
    end

    column(:organisation, header: Organisation.model_name, class: 'w-16 d-none d-sm-table-cell') do |asset|
      format(asset.organisation) do |_value|
        modal_link_to "#{icon 'fas', 'university'} #{asset.organisation}".html_safe, asset.organisation
      end
    end

    column(:actions, header: I18n.t('actions'), class: 'w-8') do |asset|
      format(asset) do |_value|
        content_tag('div') do
          if current_power.updatable_user?(asset)
            concat small_button_to t('action.edit'), edit_admin_user_path(asset), 'edit'
          end
          if current_power.destroyable_user?(asset)
            concat small_button_to I18n.t('action.archive'), [:admin, asset], 'archive', method: :delete, data: { confirm: t('are_you_sure') }
          end
        end
      end
    end
  end
end
