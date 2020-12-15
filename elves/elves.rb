num_turns = 2014
values = {0 => [1], 13 => [2], 1 => [3], 16 => [4], 6 => [5], 17 => [6]}
previous_value = 17
(7..30000000).each do |turn|
  if values[previous_value].size == 1
    values[0] << turn
    previous_value = 0
  else
    turns_spoken = values[previous_value]
    value_to_speak = (turn - 1) - turns_spoken[turns_spoken.size - 2]
    values[value_to_speak] = [] unless values.key?(value_to_speak)
    values[value_to_speak] << turn
    previous_value = value_to_speak
  end
end

puts previous_value