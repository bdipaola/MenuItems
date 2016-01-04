require 'rails_helper'
require_relative '../../app/models/SubsetSum'

describe "#Initialize" do
	let(:subset) { SubsetSum.new([2.15,2.75,3.35,3.55,5.80],15.05) }

	it 'should return the sorted array given on creation' do
	  expect(subset.sorted_array).to eq([2.15,2.75,3.35,3.55,5.80])
	end

	it 'should return the target price given during object creation' do
	  expect(subset.target_number).to eq(15.05)
	end

	it 'should return a hash of the array values' do
		expect(subset.header_index.class).to be(Hash)
	end
end

describe "#generate_matrix_header" do
	let(:subset) { SubsetSum.new([2.00,1.00],1.05) }

	it 'should return the ascending sort array ending at target number in increments of .01' do
	  expect(subset.generate_matrix_header(subset.sorted_array)).to eq([1.0, 1.01, 1.02, 1.03, 1.04, 1.05])
	end
end

describe "#generate_header_index_hash(header)" do
	let(:subset) { SubsetSum.new([2.15,2.75],15.05) }

	it 'should return a hash of the array values' do
		expect(subset.header_index.class).to be(Hash)
	end

	it 'should return a Hash with keys equal to the array values' do
		expect(subset.header_index).to have_key(2.15)
		expect(subset.header_index).to have_key(2.75)
	end

	it 'should return a Hash with values that are one greater than the header index of key to account for key location in matrix' do 
		header = subset.generate_matrix_header(subset.sorted_array)
		expect(subset.header_index[2.15]).to eq(header.index(2.15) + 1)
		expect(subset.header_index[2.75]).to eq(header.index(2.75) + 1)
	end
end

describe "#generate_default_matrix" do
	let(:subset) { SubsetSum.new([2.15,2.75,3.35,3.55,5.80],15.05) }

	it 'should return an object of type array' do
		header = subset.generate_matrix_header(subset.sorted_array)
		expect(subset.generate_default_matrix(subset.sorted_array, header).class).to be(Array)
	end

	it 'should return a nested array with the first element being the matrix header off-set by one index location' do
		header = subset.generate_matrix_header(subset.sorted_array)
		expect(subset.generate_default_matrix(subset.sorted_array, header)[0]).to eq(['M'] + header)
	end

	it 'should return a nested array of size equal to the count of the original array + 1, accounting for addition of header' do
		header = subset.generate_matrix_header(subset.sorted_array)
		expect(subset.generate_default_matrix(subset.sorted_array, header).count).to eq(subset.sorted_array.count + 1)
	end

	it 'should return a nested array where the second to (and including) the last rows have the index values of the original array in the first position'	do
		header = subset.generate_matrix_header(subset.sorted_array)
		array_index = (0..subset.sorted_array.count-1).to_a
		matrix_row_values = subset.generate_default_matrix(subset.sorted_array, header)[1..-1].map{ |row| row[0] }
		expect(matrix_row_values).to eq(array_index)
	end

	it 'should return a nested array where all interior cells have a default value of F indicating that the array values do not total to the column header value' do
		header = subset.generate_matrix_header(subset.sorted_array)
		matrix_interior = subset.generate_default_matrix(subset.sorted_array, header)[1..-1].map{ |row| row[1..-1] }.flatten
		f_count = matrix_interior.select{ |e| e=='F' }.count
		expect(matrix_interior.count).to eq(f_count)
	end
end

describe "#set_matrix_first_row" do
	let(:subset) { SubsetSum.new([2.15,2.75,3.35,3.55,5.80],15.05) }

	it 'should return an object of type array' do
		header = subset.generate_matrix_header(subset.sorted_array)
		matrix = subset.generate_default_matrix(subset.sorted_array, header)
		first_row_matrix = subset.set_matrix_first_row(matrix, subset.sorted_array)
		expect(first_row_matrix.class).to be(Array)
	end

	it 'should return an array that has a value of T beneath the header label equal to the first array (sorted) element' do
		header = subset.generate_matrix_header(subset.sorted_array)
		matrix = subset.generate_default_matrix(subset.sorted_array, header)
		first_row_matrix = subset.set_matrix_first_row(matrix, subset.sorted_array)
		index = header.index(2.15) + 1
		expect(first_row_matrix[1][index]).to eq('T')
	end
end

describe "#evaluate_matrix/#final_matrix" do
	let(:subset) { SubsetSum.new([1.0,1.01,1.04],1.02) }

	it 'should return an object of type array' do
		expect(subset.final_matrix.class).to be(Array)
	end

	it 'should return an array where rows with a T will have T in all subsequent row column combinations' do
		expect([subset.final_matrix[1][1]] + [subset.final_matrix[2][1]] + [subset.final_matrix[3][1]]).to eq(['T','T','T'])
	end

	it 'should return a cell value of T in the row when the array value indexed by the row equals the column header of the cell' do
		expect(subset.final_matrix[2][2]).to eq('T')
	end	 
end

describe "#create_matrix" do
	let(:subset) { SubsetSum.new([1.0,1.01,1.04],1.02) }

	it 'should return an object of type array' do
		expect(subset.create_matrix.class).to be(Array)
	end

	it 'should return a matrix with 4 (3 array values plus header row)' do
		expect(subset.create_matrix.count).to eq (4)
	end

	it 'should return a matrix with 12 column rows (3 for step range columns and 1 for row column)' do
		expect(subset.create_matrix[0].count).to eq (4)
	end
end

describe "#find_combinations" do
	let(:subset1) { SubsetSum.new([2.15,2.75,3.35,3.55,5.80,1.50,6.00,6.25,8.25,9.25,10.00,11.25,11.50,12.00,12.50,13.00,13.25,13.75,14.00,15.00,16.00,16.50,17.00,18.00],18.0) }
	let(:subset2) { SubsetSum.new([2.15,2.75,3.35,3.55,5.80],15.05) }

	it 'should return an empty array when no combination is found' do
		expect(subset2.find_combinations(subset2.target_number).count).to eq (0)
	end

	it 'should return an array with float values when combination is found' do
		expect(subset1.find_combinations(subset1.target_number).all?{ |element| element.class == Float }).to be (true)
	end

	it 'should return a combination array that sums to the target number if combination found' do
		expect(subset1.find_combinations(subset1.target_number).reduce(:+)).to eq (subset1.target_number)
	end
end

