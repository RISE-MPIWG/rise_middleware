module Admin
  module Collections
    class OrganisationsController < ApplicationController
      before_action :set_collection, only: %i[set_access edit update]
      before_action :set_organisation, only: %i[set_access edit update]
      before_action :set_organisation_collection, only: %i[update]

      def set_access
        @organisation.set_access_right_for_collection(@collection, access_params[:access_right])
        respond_to do |format|
          format.js {}
        end
      end

      def edit
        @organisation_collection = OrganisationCollection.find_or_create_by(organisation: @organisation, collection: @collection)
      end

      def update
        if @organisation_collection.update(organisation_collection_params)
          redirect_to [:edit, :admin, @collection, @organisation], notice: 'Organisation Access to this collection was successfully updated.'
        else
          render :edit
        end
      end

      private

      def set_organisation
        @organisation = Organisation.find(params[:id])
      end

      def set_collection
        @collection = Collection.find(params[:collection_id])
      end

      def set_organisation_collection
        @organisation_collection = OrganisationCollection.find_by(organisation_id: params[:id], collection_id: params[:collection_id])
      end

      def access_params
        params.fetch(:organisation_access, {}).permit(:access_right)
      end

      def organisation_collection_params
        params.fetch(:organisation_collection, {}).permit(:access_right, :api_key)
      end
    end
  end
end
