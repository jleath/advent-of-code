input_file = File.open('input.txt')
lines = input_file.readlines
expenses = lines.map(&:to_i)
expenses.sort!
first_index = 0
second_index = 0
third_index = 0

result = nil

while first_index < expenses.size
  second_index = 0
  first_value = expenses[first_index]
  while second_index < expenses.size
    second_value = expenses[second_index]
    third_index = 0
    while third_index < expenses.size
      third_value = expenses[third_index]
      sum = first_value + second_value + third_value
      if sum > 2020
        break
      elsif second_index != first_index && third_index != first_index && sum == 2020
        puts "#{first_value} + #{second_value} + #{third_value} == 2020"
        result = first_value * second_value * third_value
        break
      else
        third_index += 1
      end
    end
    break unless result.nil?
    second_index += 1
  end
  break unless result.nil?
  first_index += 1
end

puts result