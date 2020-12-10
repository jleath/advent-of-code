# In the input file, a '.' represents an open space, and a '#' represents a tree.

# Assume that the pattern repeats to the right. For example, on a map with 10 units
# on the x-axis. The eleventh unit will match the first, and so on.

# Processing starts on the top-left corner of the map and continues until we reach
# the bottom-most row.

# On each step, we will move 3 units to the right, and 1 unit down counting the trees
# we encounter on the way.
TREE_MARKER = '#'.freeze
SLOPES = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

def count_trees(map_rows, x_update, y_update)
  num_trees = 0
  x = 0
  y = 0
  num_rows = map_rows.size
  num_columns = map_rows.first.size
  while y < num_rows
    num_trees += 1 if map_rows[y][x] == TREE_MARKER
    x = (x + x_update) % num_columns
    y = y + y_update
  end
  num_trees
end

# Open the file
input_file = File.open("input.txt", "r")

# read the lines into an array, each array item will be a string representing one line
map_rows = input_file.readlines.map(&:strip)

total_product = 1

SLOPES.each do |coordinates|
  x_update = coordinates[0]
  y_update = coordinates[1]
  num_trees = count_trees(map_rows, x_update, y_update)
  puts "[#{x_update}, #{y_update}] -> #{num_trees} trees"
  total_product *= num_trees
end

puts "Product: #{total_product}"


# Close the file
input_file.close