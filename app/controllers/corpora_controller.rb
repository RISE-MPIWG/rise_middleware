class CorporaController < ApplicationController
  before_action :set_corpus, only: %i[show edit update add_resources tools pull_full_text full_text_search]

  require_power_check

  power crud: :corpora, as: :corpus_scope

  def index
    grid_attributes = params.fetch(:corpora_grid, {}).merge(current_power: current_power)
    @corpora_grid = CorporaGrid.new(params[:page], grid_attributes)
  end

  def show
    render layout: false
  end

  def new
    @corpus = Corpus.new
  end

  def pull_full_text
    @corpus.pull_full_text(current_user)
    render :tools
  end

  def edit; end

  def create
    @corpus = Corpus.new(corpus_params)
    @corpus.created_by = current_user
    if @corpus.save
      redirect_to Corpus, notice: 'Corpus was successfully created.'
    else
      render :new
    end
  end

  def tools
    if params && params[:tools]
      @search_term = params[:tools][:search_term]
      @search_hits = @corpus.content_units.where("content ilike '%#{@search_term}%'").uniq
    end
  end

  def add_resources
    grid_attributes = params.fetch(:corpora_add_resources_grid, {}).merge(current_power: current_power, corpus: @corpus)
    @resources_grid = Corpora::AddResourcesGrid.new(params[:page], grid_attributes)
  end

  def update
    if @corpus.update(corpus_params)
      redirect_to [:edit, @corpus], notice: 'Corpus was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_corpus
    @corpus = Corpus.find(params[:id])
  end

  def corpus_params
    params.fetch(:corpus, {}).permit(:name, :description, :privacy_type, :search_term)
  end
end
