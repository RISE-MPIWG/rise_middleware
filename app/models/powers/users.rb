module Powers
  module Users
    as_trait do
      power :users do
        User.all.active.skip_user(@user)
      end

      # TODO: creatable users power
      power :creatable_users? do
        User.all
        # case @user.role
        # when :admin then @user.organisation.active.users
        # when :super_admin then User.active
        # else
        #   User.none
        # end
      end

      power :updatable_users do
        case role_sym
        when :admin
          @user.organisation.users.active.skip_user(@user)
        when :super_admin
          User.active.skip_user(@user)
        else
          User.none
        end
      end

      power :updatable_user? do |user|
        case role_sym
        when :admin then user.organisation_id == @user.organisation_id
        when :super_admin then true
        else
          @user.id == user.id
        end
      end

      power :destroyable_user? do |user|
        case role_sym
        when :admin
          user.active? && user.organisation_id == @user.organisation_id
        when :super_admin
          user.active?
        else
          false
        end
      end

      power :destroyable_users do
        case role_sym
        when :admin
          @user.organisation.users.active
        when :super_admin
          User.active
        else
          User.none
        end
      end
    end
  end
end
