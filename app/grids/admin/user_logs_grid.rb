module Admin
  class UserLogsGrid
    include Datagrid
    attr_accessor :current_power

    def initialize(page, attributes = {})
      super(attributes)
      @current_power = attributes['current_power']
      if @current_power
        scope do
          @current_power.user_logs.order('created_at desc').page(page).per(20)
        end
      end
    end
    scope do
      UserLog.none
    end

    column(:day, header: UserLog.human_attribute_name('created_at'), class: 'w-25', order: :created_at) do |asset|
      asset.created_at.to_formatted_s(:short)
    end

    column(:user, header: User.model_name.human, class: 'w-16') do |asset|
      format(asset.loggable) do |_value|
        output = modal_link_to "#{icon 'fas', 'user'} #{asset.loggable}".html_safe, [:admin, asset.loggable]
        if current_user.super_admin?
          output += "<br> #{modal_link_to("#{icon 'fas', 'university'} #{asset.loggable.organisation}".html_safe, asset.loggable.organisation)}".html_safe
        end
        output
      end
    end
    column(:request_params, header: UserLog.human_attribute_name('params'), class: 'w-16 d-none d-sm-table-cell') do |asset|
      format(asset) do |_value|
        content_tag('pre', class: 'params-container') do
          JSON.pretty_generate(JSON.parse(asset.request_params.gsub('=>', ':')).except!('authenticity_token')).gsub(" ","&nbsp;").gsub("\\","").gsub("\"","").html_safe
        end
      end
    end
  end
end
