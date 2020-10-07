module Powers
  module Resources
    as_trait do
      power :resources do
        Resource.active.all.includes(:corpus_resources, { corpus_resources: :corpus }, :organisation, :collection, collection: { organisation: :organisation_collections })
      end

      power :readable_resources do
        if @user
          @user.organisation.resources_for_access_right(:read)
        else
          Resource.with_public_access
        end
      end

      power :readable_resource? do |resource|
        if @user
          ( @user.access_right_for_model(resource) == (:read || :owner) ) || resource.public_access?
        else
          resource.public_access?
        end
      end

      power :updatable_resources do
        case role_sym
        when :admin then @user.organisation.resources.active
        when :super_admin then Resource.active
        else
          Resource.none
        end
      end

      power :updatable_resource? do |resource|
        case role_sym
        when :admin
          resource.collection.organisation_id == @user.organisation_id
        when :super_admin
          resource.active?
        else
          false
        end
      end

      power :access_requestable_resource? do |resource|
        (resource.collection.organisation_id != @user.organisation_id) && resource.not_requested_by(@user)
      end

      power :destroyable_resource? do |resource|
        case role_sym
        when :admin
          (resource.collection.organisation_id == @user.organisation_id) && resource.active
        when :super_admin
          Resource.active
        else
          false
        end
      end

      power :destroyable_resources do
        case role_sym
        when :admin
          @user.organisation.resources.active
        when :super_active
          Resource.active
        else
          Resource.none
        end
      end

      # TODO - setup creatable power

      power :creatable_resources do
        Resource.all
        # case @user.role
        # when :admin
        #   @user.organisation.resources
        # when :super_admin
        #   Resource.all
        # else
        #   Resource.none
        # end
      end
    end
  end
end
