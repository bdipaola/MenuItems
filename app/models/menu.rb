require 'SubsetSum'
require 'MenuSubsetSelector'

class Menu < ActiveRecord::Base
	include MenusHelper

	has_many :items

	has_attached_file :menu_file
	validates_attachment_content_type :menu_file, :content_type => 'text/plain'
	validates_attachment_presence :menu_file

	validates :name, presence: {message: "Please enter a name for the menu in the input field above." }, length: { maximum: 50 }
	validate :file_present

	before_create :set_target_price_from_file
	after_create :create_items
	
	def file_present
		if !menu_file.present?
			errors.add(:file_present, "A plain text file must be selected in order to create a new menu.")
		end
	end

	def read_file_contents
  	open(self.menu_file.queued_for_write[:original].path).readlines
	end

	def set_target_price_from_file
		self.target_price = read_file_contents[0].chomp
	end

	def create_items
		menu_file_content = read_file_contents[1..-1]
		menu_file_content.each do |item|
			item_price = item.split(',')
			Item.create!(menu: self, item_name: item_price[0], price: item_price[1].chomp)
		end
	end

	def price_subset(menu_item_prices, target_price)
		SubsetSum.new(menu_item_prices, target_price).combinations
	end

	def item_subset
		price_target = convert_price_string_to_float(target_price)
		price_values = price_subset(menu_prices_to_float(menu_items), price_target)
		selector = MenuSubsetSelector.new(price_values.uniq)
		price_item_hash = selector.price_item_hash(menu_items)
		selector.subset_items(price_values, price_item_hash)
	end
end
