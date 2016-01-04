module MenusHelper
	def menu_items
		Item.where(menu_id: self.id)
	end

	def convert_price_string_to_float(price_string)
		price_string.gsub(/[$]/,'').to_f.round(2)
	end

	def menu_prices_to_float(menu_items)
		menu_items.map { |item| convert_price_string_to_float(item.price) }
	end
end