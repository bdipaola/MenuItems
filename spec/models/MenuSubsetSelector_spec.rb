require 'rails_helper'
require_relative '../../app/models/MenuSubsetSelector'

describe "#price_item_hash" do
	let(:selector) { MenuSubsetSelector.new([2.15,2.75,2.75,3.35,3.55,5.80,1.50,6.00,6.25,8.25,9.25,10.00,11.25,11.50,12.00,12.50,13.00,13.25,13.75,14.00,15.00,16.00,16.50,17.00,18.00]) }
	
	items = []
	item_names = %w(item1 item2 item3 item4 item5 item6 item7 item8 item9 item10 item11 item12 item13 item14 item15 item16 item17 item18 item19 item20 item21 item22 item23 item24 item25)
	item_prices = [2.15,2.75,2.75,3.35,3.55,5.80,1.50,6.00,6.25,8.25,9.25,10.00,11.25,11.50,12.00,12.50,13.00,13.25,13.75,14.00,15.00,16.00,16.50,17.00,18.00]
	item_prices.each_with_index { |price,index| items << Item.new(item_name: item_names[index], price: price) }

	it 'should return a hash object' do
		expect(selector.price_item_hash(items).class).to be(Hash)
	end

	it 'should return a hash object with price or float keys' do
		expect(selector.price_item_hash(items).has_key?(item_prices[0])).to be(true)
	end

	it 'should return values of type array' do
		expect(selector.price_item_hash(items)[item_prices[0]].class).to be(Array)
	end

	it 'should return values of type array that contain Item objects' do
		expect(selector.price_item_hash(items)[item_prices[0]].first.class).to be(Item)
	end
	
	it 'should return values of type array with more than one item object when those objects share the same price' do
		# expect(selector.price_item_hash(items)[item_prices[0]].all?{ |item| item.price == item_prices[0] }).to be(true)
		expect(selector.price_item_hash(items)[item_prices[1]].all?{ |item| item.price == "2.75" }).to be(true)
	end
end

describe "#subset_items" do
	let(:selector) { MenuSubsetSelector.new([2.15, 2.75, 3.35]) }

	items = []
	item_names = %w(item1 item2 item3 item4 item5 item6 item7 item8 item9 item10 item11 item12 item13 item14 item15 item16 item17 item18 item19 item20 item21 item22 item23 item24 item25)
	item_prices = [2.15,2.75,2.75,3.35,3.55,5.80,1.50,6.00,6.25,8.25,9.25,10.00,11.25,11.50,12.00,12.50,13.00,13.25,13.75,14.00,15.00,16.00,16.50,17.00,18.00]
	item_prices.each_with_index { |price,index| items << Item.new(item_name: item_names[index], price: price) }

	combination_prices = [2.15, 2.75, 3.35]

	it 'should return an array' do
		hash = selector.price_item_hash(items)
		expect(selector.subset_items(combination_prices, hash).class).to be(Array)
	end

	it 'should return an array with 3 elements representing combination prices' do
		hash = selector.price_item_hash(items)
		expect(selector.subset_items(combination_prices, hash).count).to eq(3)
	end

	it 'should return an array of Item objects' do
		hash = selector.price_item_hash(items)
		expect(selector.subset_items(combination_prices, hash).all?{ |element| element.class == Item }).to be(true)
	end
end

