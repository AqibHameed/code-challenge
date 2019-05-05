json.extract! @asset,:address, :zipcode, :city
json.year_of_construction @asset.yoc
json.restricted_area @asset.is_restricted
json.number_of_units @number_of_units
json.total_rent @total_rent
json.total_area @total_area
json.area_rented @area_rented
json.vacancy @vaccany
json.walt @walt
json.latest_update @asset.date