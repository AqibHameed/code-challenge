require 'csv'

namespace :import_units_20190101_csv do
  task :create_or_update_db => :environment do
    csv = CSV.foreach(Rails.root.join('lib/tasks/units_20190201.csv'), :headers => true, :col_sep => ';')

    csv.each do |row|
      portfolio = Portfolio.find_or_create_by(name: row["﻿portfolio"])
      asset = Asset.find_by_asset_ref(row["asset_ref"])
      unit = Unit.find_by_unit_ref(row["unit_ref"])

      lease_start = Date.strptime(row["unit_lease_start"], '%d.%m.%Y') if row["unit_lease_start"].present?
      lease_end = Date.strptime(row["unit_lease_end"], '%d.%m.%Y') if row["unit_lease_end"].present?
      updated_date = Date.strptime(row["data_timestamp"], '%d.%m.%Y') if row["data_timestamp"].present?

      if row["unit_type"] == "RESIDENTIAL"
        unit_type = 0
      elsif row["unit_type"] == "OFFICE"
        unit_type = 1
      elsif row["unit_type"] == "RETAIL"
        unit_type = 2
      end

      if asset.present?
        asset.update_attributes(portfolio_id: portfolio.id, address: row["asset_address"], zipcode: row["asset_zipcode"],
                                city: row["asset_city"], is_restricted: row["asset_is_restricted"],
                                yoc: row["asset_yoc"], asset_ref: row["asset_ref"], date: updated_date)
      else
        portfolio.assets.create(address: row["asset_address"], zipcode: row["asset_zipcode"],city: row["asset_city"],
                                is_restricted: row["asset_is_restricted"], yoc: row["asset_yoc"],
                                asset_ref: row["asset_ref"], date: updated_date)
      end

      asset =  Asset.find_by_asset_ref(row["asset_ref"])

      if unit.present?

        unit.update_attributes(asset_id: asset.id, size: row["unit_size"],is_rented: row["unit_is_rented"],
                                unit_ref: row["unit_ref"], rent: row["unit_rent"],unit_type: unit_type,
                                tenant: row["unit_tenant"], lease_start: lease_start,lease_end: lease_end)
      else

        asset.units.create(size: row["unit_size"],is_rented: row["unit_is_rented"],
                           unit_ref: row["unit_ref"], rent: row["unit_rent"],unit_type: unit_type,
                           tenant: row["unit_tenant"],
                           lease_start: lease_start,lease_end: lease_end)

      end


    end
  end
end