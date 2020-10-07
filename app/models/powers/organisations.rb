module Powers
  module Organisations
    as_trait do
      power :organisations do
        Organisation.active.includes(:organisation_collections, organisation_collections: :collection)
      end

      power :updatable_organisations do
        case role_sym
        when :admin
          @user.organisation
        when :super_admin
          Organisation.active
        else
          Organisation.none
        end
      end

      power :updatable_organisation?, :destroyable_organisation? do |organisation|
        case role_sym
        when :admin
          organisation == @user.organisation
        when :super_admin
          Organisation.active
        else
          Organisation.none
        end
      end

      power :creatable_organisations do
        if @user.super_admin?
          Organisation.all
        else
          Organisation.none
        end
      end

      power :destroyable_organisations do
        if @user.super_admin?
          Organisation.all
        else
          Organisation.none
        end
      end
    end
  end
end
