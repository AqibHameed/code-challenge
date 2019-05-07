class AssetsController < ApplicationController
  before_action :set_asset, only: [:show]

=begin
 @apiVersion 1.0.0
 @api {get} /assets
 @apiSampleRequest off
 @apiName index
 @apiGroup Asset
 @apiDescription get all aggregate information of  all assets
 @apiSuccessExample {json} SuccessResponse:
 [
    {
        "address": "Am Kupfergraben 6",
        "city": "Berlin",
        "zipcode": "10117",
        "year_of_construction": 1876,
        "restricted_area": true,
        "number_of_units": 6,
        "total_rent": 6600,
        "total_area": 745,
        "area_rented": 650,
        "vacancy": "12%",
        "walt": 11.5,
        "latest_update": "0019-01-01T00:00:00.000Z"
    },
    {
        "address": "Spreeweg 1",
        "city": "Berlin",
        "zipcode": "10557",
        "year_of_construction": 1786,
        "restricted_area": true,
        "number_of_units": 1,
        "total_rent": 20000,
        "total_area": 4000,
        "area_rented": 4000,
        "vacancy": "0%",
        "walt": 5,
        "latest_update": "0019-01-01T00:00:00.000Z"
    },
    {
        "address": "Potsdamer Platz 3",
        "city": "Berlin",
        "zipcode": "10785",
        "year_of_construction": 1961,
        "restricted_area": false,
        "number_of_units": 9,
        "total_rent": 32830,
        "total_area": 2505,
        "area_rented": 1805,
        "vacancy": "27%",
        "walt": 10.2,
        "latest_update": "0019-01-01T00:00:00.000Z"
    },
    {
        "address": "Neuer Wall 17",
        "city": "Hamburg",
        "zipcode": "20354",
        "year_of_construction": 2002,
        "restricted_area": false,
        "number_of_units": 4,
        "total_rent": 24000,
        "total_area": 800,
        "area_rented": 800,
        "vacancy": "0%",
        "walt": 20,
        "latest_update": "0019-01-01T00:00:00.000Z"
    },
    {
        "address": "Fritz-Löffler-Straße 16",
        "city": "Dresden",
        "zipcode": "1069",
        "year_of_construction": 1995,
        "restricted_area": false,
        "number_of_units": 7,
        "total_rent": 7900,
        "total_area": 359,
        "area_rented": 269,
        "vacancy": "25%",
        "walt": 3.8,
        "latest_update": "0019-01-01T00:00:00.000Z"
    }
]

=end

  def index
      @assets = Asset.sort_by_latest_update

      render status: :ok, template: "assets/index.json.jbuilder"
  end

=begin
  @apiVersion 1.0.0
  @api {get} /assets/:id
  @apiParam {Number} id Assets unique ID.
  @apiSampleRequest off
  @apiName show
  @apiGroup Asset
  @apiDescription get only single aggregate information of  asset
  @apiSuccessExample {json} SuccessResponse:
  {
    "address": "Am Kupfergraben 6",
    "city": "Berlin",
    "zipcode": "10117",
    "year_of_construction": 1876,
    "restricted_area": true,
    "number_of_units": 6,
    "total_rent": 6600,
    "total_area": 745,
    "area_rented": 650,
    "vacancy": "12%",
    "walt": 11.5,
    "latest_update": "0019-01-01T00:00:00.000Z"
  }
=end

  def show
    if @asset.present?
      @number_of_units =  @asset.number_of_units
      @total_rent = @asset.total_rent
      @total_area = @asset.total_area
      @area_rented = @asset.total_area_rented
      @vaccany = @asset.vacant_area(@total_area)
      @walt = @asset.calculate_walt(@total_area)

      render status: :ok, template: "assets/show.json.jbuilder"
    else
      render status: :unprocessable_entity, json: {errors: "asset must be exist"}
    end

  end

=begin
  @apiVersion 1.0.0
  @api {post} /upload_file
  @apiParam {File} file CSV file.
  @apiSampleRequest off
  @apiName upload_csv_file
  @apiGroup Asset
  @apiDescription upload the csv file
  @apiSuccessExample {json} SuccessResponse:
  {
    {"message":"File uploaded successfully"}
  }
=end

  def upload_csv_file
    begin
      Asset.import(params[:file])
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
