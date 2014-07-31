class DataQueriesController < ApplicationController
  before_action :set_data_query, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /data_queries
  # GET /data_queries.json
  def index
    @data_queries = current_user.data_queries
  end

  # GET /data_queries/1
  # GET /data_queries/1.json
  def show
  end

  # GET /data_queries/new
  def new
    @data_query = DataQuery.new
  end

  # GET /data_queries/1/edit
  def edit
  end

  # POST /data_queries
  # POST /data_queries.json
  def create
    @data_query = DataQuery.new(data_query_params)
    @data_query.user = current_user

    respond_to do |format|
      if @data_query.save
        format.html { redirect_to @data_query, notice: 'Data query was successfully created.' }
        format.json { render :show, status: :created, location: @data_query }
      else
        format.html { render :new }
        format.json { render json: @data_query.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_queries/1
  # PATCH/PUT /data_queries/1.json
  def update
    respond_to do |format|
      if @data_query.update(data_query_params)
        format.html { redirect_to @data_query, notice: 'Data query was successfully updated.' }
        format.json { render :show, status: :ok, location: @data_query }
      else
        format.html { render :edit }
        format.json { render json: @data_query.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_queries/1
  # DELETE /data_queries/1.json
  def destroy
    @data_query.destroy
    respond_to do |format|
      format.html { redirect_to data_queries_url, notice: 'Data query was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_query
      @data_query = DataQuery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_query_params
      params.require(:data_query).permit(:content, :name)
    end
end
