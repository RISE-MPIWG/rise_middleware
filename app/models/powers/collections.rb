module Powers
  module Collections
    as_trait do
      power :collections do
        Collection.active.includes(organisation: :organisation_collections)
      end

      power :creatable_collections do
        Collection.all
      end

      power :readable_collections do
        if @user
          @user.organisation.collections_for_access_right(:read) || @user.organisation_id == collection.organisation_id
        else
          Collection.with_public_access
        end
      end

      power :readable_collection? do |collection|
        if @user
          @user.access_right_for_model(collection) == :read || collection.public_access?
        else
          collection.public_access?
        end
      end

      power :mineable_collection do |_collection|
        @user.organisation.collections_for_access_right(:mine)
      end

      power :updatable_collections do
        case role_sym
        when :admin
          @user.organisation.collections.active.includes(organisation: :organisation_collections)
        when :super_admin
          Collection.active
        else
          Collection.none
        end
      end

      power :updatable_collection? do |collection|
        case role_sym
        when :admin
          (collection.organisation_id == @user.organisation_id)
        when :super_admin
          Collection.active
        else
          false
        end
      end

      power :destroyable_collection? do |collection|
        case role_sym
        when :admin
          (collection.organisation_id == @user.organisation_id) && collection.active?
        when :super_admin
          collection.active
        else
          false
        end
      end

      power :destroyable_collections do
        case role_sym
        when :admin
          @user.organisation.collections.active
        when :super_admin
          Collection.active
        else
          Collection.none
        end
      end
    end
  end
end
