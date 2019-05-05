class Unit < ApplicationRecord
  belongs_to :asset

  enum unit_type: ["RESIDENTIAL", "OFFICE", "RETAIL"]
end
