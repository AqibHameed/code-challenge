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
    units = self.units.where.not(tenant: nil, lease_start: nil, lease_end: nil).group(:tenant)
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
    walt_sum
  end
end
