module ControllerMacros

  def create_units(asset)
      create(:unit, asset_id: asset.id, tenant: "Aqib Hameed", lease_start: 2.years.ago, lease_end: 3.years.since)
      create(:unit, asset_id: asset.id, tenant: "Wasim Hameed", lease_start: 2.years.ago, lease_end: 2.years.since)
      create(:unit, asset_id: asset.id, tenant: "Aqib Hameed", lease_start: 2.years.ago, lease_end: 4.years.since)
      create(:unit, asset_id: asset.id, tenant: "Aqib Hameed", lease_start: 1.years.ago, lease_end: 5.years.since)
      create(:unit, asset_id: asset.id, lease_start: 2.years.ago, lease_end: 5.years.since)
  end

end