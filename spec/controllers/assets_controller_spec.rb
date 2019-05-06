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
  end
end
