class MenuSubsetSelector
	include MenusHelper

	def initialize(combination_values)
		@combination_values = combination_values
	end

	def price_item_hash(menu_items)
		price_item_hash = Hash.new([])
		menu_items.each do |item|
			price_value = convert_price_string_to_float(item.price)
			price_item_hash[price_value] += [item]
		end
		price_item_hash 
	end

	def subset_items(combination_values, price_item_hash)
		subset = []
		if combination_values.count > 0
			combination_values.each do |price| 
				item = price_item_hash[price].sample
				subset << item
			end
		end
		subset
	end
end