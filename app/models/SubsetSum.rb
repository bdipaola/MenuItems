class SubsetSum
	attr_reader :sorted_array, :final_matrix, :combinations, :target_number, :header_index
	
	def initialize(array, target)
		@sorted_array = array.sort
		@target_number = target
		@header_index = generate_header_index_hash(generate_matrix_header(sorted_array))
		@final_matrix = create_matrix
		@combinations = find_combinations(target)
	end

	def generate_matrix_header(array)
		(array[0]..target_number).step(0.01).map{ |element| element.round(2) }		
	end

	def generate_default_matrix(array, header)
		matrix = []
		header = ['M'] + header
		matrix << header
		array.each_with_index do |element, index|
			row = header.map { |cell| 'F' }
			row[0] = index
			matrix << row
		end
		matrix
	end

	def set_matrix_first_row(default_matrix, array)
		default_matrix.each_with_index do |cell, index|
			if default_matrix[0][index] == array[0]
				default_matrix[1][index] = 'T'
			end
		end
		default_matrix
	end

	def evaluate_matrix(first_row_matrix, array)
		(2...first_row_matrix.count).each do |row|
			first_row_matrix[row].each_with_index do |cell, index|
				if first_row_matrix[row-1][index] == 'T' || array[first_row_matrix[row][0]] == first_row_matrix[0][index] || related_cell?(first_row_matrix, array, row, index)
					first_row_matrix[row][index] = 'T'
				end
			end
		end
		first_row_matrix
	end

	def related_cell?(matrix, array, row, index)
		if matrix[row][index] == 'F'
			value = matrix[0][index] - array[matrix[row][0]]
			return true if header_index[value] && matrix[0][header_index[value]] == value && matrix[row-1][header_index[value]] == 'T'
		end
		false
	end

	def generate_header_index_hash(header)
		header_index_hash = {}
		header.each_with_index do |value, index|
			header_index_hash[value] = index + 1
		end
		header_index_hash
	end

	def create_matrix
		header = generate_matrix_header(sorted_array)
		matrix = generate_default_matrix(sorted_array, header)
		first_row_matrix = set_matrix_first_row(matrix, sorted_array)
		evaluate_matrix(first_row_matrix, sorted_array)
	end

	def find_combinations(target_number)
		combinations = []
		index = header_index[target_number]
		(1...final_matrix.count).to_a.reverse.each do |row|
			if final_matrix[row][index] == 'F'
				return combinations
			elsif final_matrix[row][index] == 'T' && (final_matrix[row-1][index] == 'F' || final_matrix[row-1][index] != 'T')
		  	combinations << sorted_array[row-1]
		  	new_column_value = final_matrix[0][index] - sorted_array[row-1]
		  	index = header_index[new_column_value] if header_index[new_column_value]
		  else
				next
			end
		end
		combinations
	end

	def to_s
		puts "Array: #{sorted_array}\nTarget: #{target_number}"
		final_matrix.each do |row|
			p row
		end
	end
end