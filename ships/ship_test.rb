require_relative 'ships'

input_file = File.open('input.txt')
instructions = input_file.readlines.map(&:chomp)
input_file.close

ship = Ship.new

instructions.each do |instruction|
  op = instruction[0]
  value = instruction.slice(1, instruction.size - 1).to_i
  ship.command(op, value)
end

puts ship.manhattan_distance