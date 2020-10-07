module Corpora
  class ResourcesController < ApplicationController
    before_action :set_corpus, only: %i[show index destroy add remove]
    before_action :set_resource, only: %i[show destroy add remove pull_full_text]

    def index
      grid_attributes = params.fetch(:corpora_resources_grid, {}).merge(current_power: current_power, corpus: @corpus)
      @resources_grid = Corpora::ResourcesGrid.new(params[:page], grid_attributes)
    end

    def show
      render '/resources/show'
    end

    def add
      @corpus.resources << @resource
      attributes = {}
      attributes[:user_id] = current_user.id
      attributes[:resource_id] = @resource.id
      ResourcePullFullTextJob.perform_later(attributes)
      @corpus.save
      respond_to do |format|
        format.js {}
      end
    end

    def remove
      CorpusResource.find_by(corpus_id: @corpus.id, resource_id: @resource.id).destroy
      respond_to do |format|
        format.js {}
      end
    end

    def destroy
      CorpusResource.find_by(corpus_id: @corpus.id, resource_id: @resource.id).destroy
      respond_to do |format|
        format.js {}
      end
    end

    def request_access
      user_resource = UserResource.find_or_create_by(user_id: current_user.id, resource_id: @resource.id)
      user_resource.access_right = :requested
      user_resource.save
      # TODO Send a notification mail to the owner of the resource
      redirect_to resources_url, notice: 'You have successfully requested acccess to this resource - the administator of this resource has been notified and will treat your case as soon as possible.'
    end

    private

    def set_resource
      @resource = Resource.find(params[:id])
    end

    def set_corpus
      @corpus = Corpus.find(params[:corpus_id])
    end

    def resource_params
      params.fetch(:resource, {})
    end
  end
end
