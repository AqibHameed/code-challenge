require 'rails_helper'

RSpec.describe Asset, type: :model do
  it { should have_many(:units) }
  it { should belong_to(:portfolio) }
end
