# require 'SubsetSum'
# require 'MenuSubsetSelector'

def show_items
	items = []
	item_names = %w(item1 item2 item3 item4 item5 item6 item7 item8 item9 item10 item11 item12 item13 item14 item15 item16 item17 item18 item19 item20 item21 item22 item23 item24 item25)
	item_prices = [2.15,2.75,2.75,3.35,3.55,5.80,1.50,6.00,6.25,8.25,9.25,10.00,11.25,11.50,12.00,12.50,13.00,13.25,13.75,14.00,15.00,16.00,16.50,17.00,18.00]
	item_prices.each_with_index { |price,index| items << Item.new(item_name: item_names[index], price: price) }
	items
end

def show_hash(show_items)
	a = MenuSubsetSelector.new([2.15,2.75,3.35,3.55,5.80,1.50,6.00,6.25,8.25,9.25,10.00,11.25,11.50,12.00,12.50,13.00,13.25,13.75,14.00,15.00,16.00,16.50,17.00,18.00])
	a.price_item_hash(show_items)
end