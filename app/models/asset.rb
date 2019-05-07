class Asset < ApplicationRecord
  has_many :units
  belongs_to :portfolio

  scope :sort_by_latest_update, -> {includes(:units).sort_by(&:date)}

  def number_of_units
     units.count
  end

  def total_rent
      units.sum(:rent)
  end

  def total_area
     units.sum(:size)
  end

  def total_area_rented
    units.where(is_rented: true).sum(:size)
  end

  def vacant_area(total_area)
    vacancy_area = units.where(tenant: nil).sum(:size)
    ((vacancy_area.to_f/total_area) * 100).to_i
  end

  def calculate_walt(total_area)
    units = self.units.where.not(tenant: nil, lease_start: nil, lease_end: nil).where(is_rented: true).group(:tenant)
    total_occupy_area_by_tenants = units.sum(:size)
    walt_sum = 0
    total_occupy_area_by_tenants.each do |tenant, tenant_occupy_area|
      unit = units.find_by_tenant(tenant)
      lease_start = unit.lease_start.to_date
      lease_end = unit.lease_end.to_date
      lease_expires = ((lease_end - lease_start)/365).floor
      tenant_occupy_percentage = (((tenant_occupy_area.to_f/total_area)* 100).to_i).to_f/100
      walt_sum += tenant_occupy_percentage * lease_expires
    end
    '%.1f' % walt_sum
  end

  def self.import(file)
    csv = CSV.foreach(file.path, :headers => true, :col_sep => ';')

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
