def calculate_departure(id, earliest_timestamp)
  div, mod = earliest_timestamp.divmod(id)
  return earliest_timestamp if mod == 0
  (div * id) + id
end

def matches_offset(timestamp, bus_id, offset)
  calculate_departure(bus_id, timestamp) - timestamp == offset
end

def calculate_first_alignment(departures)
  start = 0
  incrementer = 1
  departures.each do |bus_id, offset|
    while (start + offset) % bus_id != 0
      start += incrementer
    end
    incrementer *= bus_id
  end
  start
end

input_file = File.open('input.txt', 'r')
data = input_file.readlines.map(&:chomp)
input_file.close
earliest_departure = data[0].to_i
buses = data[1].split(',')
buses = buses.reject {|id| id == 'x' }.map(&:to_i)

departures = {}
best_option = nil
buses.each do |bus_id|
  earliest = calculate_departure(bus_id, earliest_departure)
  departures[bus_id] = earliest
  best_option = bus_id if best_option.nil? || earliest < departures[best_option]
end

puts best_option * (departures[best_option] - earliest_departure)

departures = {}
data[1].split(',').each_with_index do |bus_id, index| 
  departures[bus_id.to_i] = index unless bus_id == 'x'
end

puts calculate_first_alignment(departures)
