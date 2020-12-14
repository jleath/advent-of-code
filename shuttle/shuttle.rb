def calculate_departure(id, earliest_timestamp)
  div, mod = earliest_timestamp.divmod(id)
  return earliest_timestamp if mod == 0
  (div * id) + id
end

def matches_offset(timestamp, bus_id, offset)
  calculate_departure(bus_id, timestamp) - timestamp == offset
end

def gcd(x, y)
  remainder = 0
  loop do
    break if y.zero?

    remainder = x % y
    x = y
    y = remainder
  end
  x
end

def least_common_multiple(x, y)
  (x * y) / gcd(x, y)
end

input_file = File.open('small_input.txt', 'r')
data = input_file.readlines.map(&:chomp)
input_file.close
earliest_departure = data[0].to_i
buses = data[1].split(',')
buses = buses.reject {|id| id == 'x' }.map(&:to_i)

def extended_gcd(a, b)
  old_r, r = a, b
  old_s, s = 1, 0
  old_t, t = 0, 1
  while r != 0
    quotient, remainder = old_r.divmod(r)
    old_r, r = r, remainder
    old_s, s = s, old_s - quotient * s
    old_t, t = t, old_t - quotient * t
  end
  [old_r, old_s, old_t]
end

departures = {}
best_option = nil
buses.each do |bus_id|
  earliest = calculate_departure(bus_id, earliest_departure)
  departures[bus_id] = earliest
  best_option = bus_id if best_option.nil? || earliest < departures[best_option]
end

puts best_option * (departures[best_option] - earliest_departure)

# Assume that we have a fixed timestamp t the begins a pattern where each bus
# departs in manner so that departure - t equals the index of that bus in our input
# find the earliest timestamp for which this pattern occurs

# start with the naive case

departure_offsets = {}
data[1].split(',').each_with_index do |bus_id, index| 
  departure_offsets[bus_id.to_i] = index unless bus_id == 'x'
end

longest_route = departure_offsets.keys.max
largest_offset = departure_offsets.values.max
shortest_route = departure_offsets.keys.min
smallest_offset = departure_offsets.values.min

gcd, s, t = extended_gcd(longest_route, shortest_route)

start_time = Time.now
t = longest_route - departure_offsets[longest_route]
loop do
  if departure_offsets.all? { |id, offset| matches_offset(t, id, offset)}
    break
  end
  t += longest_route
end
end_time = Time.now

puts t
puts "Completed in #{end_time - start_time}"
