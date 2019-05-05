json.extract! asset, :address, :zipcode, :city
json.year_of_construction asset.yoc
json.restricted_area asset.is_restricted
json.number_of_units asset.number_of_units
json.total_rent asset.total_rent
json.total_area asset.total_area
json.area_rented asset.total_area_rented
json.vacancy asset.vacant_area(asset.total_area)
json.walt asset.calculate_walt(asset.total_area)
json.latest_update asset.date