class AssetsController < ApplicationController
  before_action :set_asset, only: [:show]

  def index
    begin
      @assets = Asset.sort_by_latest_update
      render status: :ok, template: "assets/index.json.jbuilder"
    rescue Exception => e
      render status: :unprocessable_entity, json: {errors: e.message}
    end
  end

  def show
    begin
      @number_of_units =  @asset.number_of_units
      @total_rent = @asset.total_rent
      @total_area = @asset.total_area
      @area_rented = @asset.total_area_rented
      @vaccany = @asset.vacant_area(@total_area)
      @walt = @asset.calculate_walt(@total_area)

      render status: :ok, template: "assets/show.json.jbuilder"
    rescue Exception => e
      render status: :unprocessable_entity, json: {errors: e.message}
    end

  end



  def upload_csv_file
    begin
      Asset.import(params[:file])
      #rake import_units_20190101_csv:create_or_update_db
      render status: :ok , json: {message: "File uploaded successfully"}
    rescue Exception => e
      render status: :unprocessable_entity, json: {errors: e.message}
    end
  end

  private
  def set_asset
    @asset = Asset.find_by(id: params[:id])
  end
end
