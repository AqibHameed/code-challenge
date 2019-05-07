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
      end
    end

    context "when user upload the csv file" do
      it "can upload a license" do
        @file = fixture_file_upload('files/units_20190101.csv', 'text/csv')
        post :upload_csv_file, params: {file: @file}
        expect(JSON.parse(response.body)['message']).to eq("File uploaded successfully")
      end
    end
  end
end
