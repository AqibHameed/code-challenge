json.extract! asset, :address, :city
json.zipcode asset.zipcode.to_s
json.year_of_construction asset.yoc
json.restricted_area asset.is_restricted
json.number_of_units asset.number_of_units
json.total_rent asset.total_rent
json.total_area asset.total_area
json.area_rented asset.total_area_rented
json.vacancy asset.vacant_area(asset.total_area).to_s+'%'
json.walt asset.calculate_walt(asset.total_area).to_f
json.latest_update asset.date