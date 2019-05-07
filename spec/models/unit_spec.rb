require 'rails_helper'

RSpec.describe Unit, type: :model do
  it { should belong_to(:asset) }
end
