module Powers
  module Roles
    as_trait do
      def role_sym
        @role_sym ||= @user.role.to_sym
      end

      power :admin? do
        @is_admin ||= (@user.admin? || @user.super_admin?) if @user
      end

      power :super_admin? do
        @user.super_admin?
      end
    end
  end
end
