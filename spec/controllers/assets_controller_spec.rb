require 'rails_helper'

RSpec.describe AssetsController, type: :controller do
  render_views

  before(:all) do
    @postfolio = create(:portfolio)
    @asset = create(:asset, portfolio_id: @postfolio.id, date: Date.today - 1)
    create_units(@asset)

  end

  describe '#index' do
    context 'when user fetch all assets record' do
      it 'does show aggregate information of all assets' do
        get :index, :format => :json
        expect(JSON.parse(response.body).first['address']).to eq(@asset.address)
        expect(JSON.parse(response.body).first['zipcode']).to eq(@asset.zipcode.to_s)
        expect(JSON.parse(response.body).first['city']).to eq(@asset.city)
        expect(JSON.parse(response.body).first['year_of_construction']).to eq(@asset.yoc)
        expect(JSON.parse(response.body).first['number_of_units']).to eq(5)
        expect(JSON.parse(response.body).first['total_rent']).to eq(2500)
        expect(JSON.parse(response.body).first['total_area']).to eq(750)
        expect(JSON.parse(response.body).first['area_rented']).to eq(750)
        expect(JSON.parse(response.body).first['vacancy']).to eq('20%')
        expect(JSON.parse(response.body).first['walt']).to eq(3.8)
      end
    end
  end

  describe '#show' do
    context 'when user fetch the single record of asset' do
      it 'does show aggregate information of the asset' do
        get :show, params: {id: 1}
        expect(JSON.parse(response.body)['address']).to eq(@asset.address)
        expect(JSON.parse(response.body)['zipcode']).to eq(@asset.zipcode.to_s)
        expect(JSON.parse(response.body)['city']).to eq(@asset.city)
        expect(JSON.parse(response.body)['year_of_construction']).to eq(@asset.yoc)
        expect(JSON.parse(response.body)['number_of_units']).to eq(5)
        expect(JSON.parse(response.body)['total_rent']).to eq(2500)
        expect(JSON.parse(response.body)['total_area']).to eq(750)
        expect(JSON.parse(response.body)['area_rented']).to eq(750)
        expect(JSON.parse(response.body)['vacancy']).to eq('20%')
        expect(JSON.parse(response.body)['walt']).to eq(3.8)
      end
    end

    context 'when user fetch the asset with unknown id' do
      it 'does show the message asset must be exist' do
        get :show, params: {id: 7}
        expect(JSON.parse(response.body)['errors']).to eq("asset must be exist")
      end
    end
  end

  describe '#upload_csv_file' do
    context "when user upload the csv file" do
      it "can upload a file" do
        @file = fixture_file_upload('files/units_20190101.csv', 'text/csv')
        post :upload_csv_file, params: {file: @file}
        expect(JSON.parse(response.body)['message']).to eq("File uploaded successfully")
      end
    end
  end
end
