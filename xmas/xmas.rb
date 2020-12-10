# Given a file of integers, find the first number (after the 25 number preamble)
# which is NOT the sum of two of the 25 numbers before it.

# The given numbers are in random order, and we cannot alter the order of the original list
# of numbers.

# We could slice out the 25 numbers preceeding the current number and alter that subarray

# For each number, we need to extract the 25 numbers before it and determine whether that
# list of 25 numbers contains exactly two numbers that sum to the current number.
# There could potentially be more than one pair of numbers that sums to our current number.

# We have a total of 1000 numbers, if we use an algorithm that has to check every pair of numbers
# one by one, we could potentially need to check this about 1000 * 25^2 times.
# Given this sample size, an O(n2) algorithm is feasable.

# Since we cannot sort the whole list, and we need to perform potentially 1000 searches, we don't want
# to just grab a chunk of 25 numbers each time and sort them. Instead, we will sort the first 25 numbers,
# and maintain a sorted list of 25 integers as we move through the list of numbers. Dropping the first one,
# and inserting the next one in the correct place

# So when we check the 26th number, we will put the first 25 numbers into an array and sort it.
# We will then iterate through those 25 numbers, for each number, we'll check the rest of the 25 numbers one by one
# looking for the one that gets the sum up to the number we are searching for. If the sum of these two numbers is greater
# than our sought number, we will start again from the second number in the list of 25.
# If we get to a point in the list of 25 where two consecutive numbers are larger than our sought number, we know we
# found a number that cannot meet the requirements. and we can output that number.

input_file = File.open('input.txt', 'r')
numbers = input_file.readlines.map do |line|
  line.chomp.to_i
end
input_file.close

# Assumes array is sorted
def has_sum_pair?(array, value)
  index = 0
  while index < array.size - 1
    other_index = index + 1
    first_number = array[index]
    needed_value = value - first_number
    while other_index < array.size
      break if array[other_index] > needed_value
      return true if array[other_index] == needed_value
      other_index += 1
    end
    index += 1
  end
  false
end

def find_invalid_value(array)
  index_to_check = 0
  loop do
    sought_number = array[index_to_check + 25]
    preamble = array.slice(index_to_check, 25).sort
    return sought_number unless has_sum_pair?(preamble, sought_number)

    index_to_check += 1
  end
end

def find_contiguous_sum(array, value)
  index = 0
  smallest_seen = nil
  largest_seen = nil
  while index < array.size
    other_index = index + 1
    curr_sum = array[index]
    smallest_seen = curr_sum
    largest_seen = curr_sum
    loop do
      break if other_index >= array.size || curr_sum + array[other_index] > value

      curr_sum += array[other_index]
      if array[other_index] < smallest_seen
        smallest_seen = array[other_index]
      end
      if array[other_index] > largest_seen
        largest_seen = array[other_index]
      end
      return smallest_seen + largest_seen if curr_sum == value
      other_index += 1
    end
    index += 1
  end
end

invalid_value = find_invalid_value(numbers)
puts "Found invalid value: #{invalid_value}"
puts find_contiguous_sum(numbers, invalid_value)
