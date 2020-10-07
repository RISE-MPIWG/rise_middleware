module Powers
  module UserLogs
    as_trait do
      power :user_logs do
        case role_sym
        when :admin
          UserLog.where(organisation_id: @user.organisation_id)
        when :super_admin
          UserLog.all
        else
          UserLog.none
        end
      end
    end
  end
end
