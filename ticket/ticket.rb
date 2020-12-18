# Input describes rules for ticket fields, the numbers on the ticket
# and the numbers on other nearby tickets

# rules for ticket fields specify a list of fields that exist somewhere
# on the ticket and valid ranges of values for each field.

input_file = File.open('input.txt', 'r')

def build_rules(input_file)
  input_file.rewind
  lines = input_file.readlines.map(&:chomp)
  lines.each_with_object({}) do |line, rules|
    break rules if line.empty?

    rule_key = line.match(/[^:]+/).to_s
    rule_ranges = line.scan(/\d+-\d+/)
    rules[rule_key] = rule_ranges.map do |range_str| 
      lowest, highest = range_str.scan(/\d+/).map(&:to_i)
      Range.new(lowest, highest)
    end
  end
end

def get_my_ticket(input_file)
  input_file.rewind
  loop do
    line = input_file.readline.chomp
    if line == 'your ticket:'
      return input_file.readline.chomp.scan(/\d+/).map(&:to_i)
    end
  end
end

def get_nearby_tickets(input_file)
  input_file.rewind
  loop do
    line = input_file.readline.chomp
    break if line == 'nearby tickets:'
  end
  nearby_ticket_lines = input_file.readlines.map(&:chomp)
  nearby_ticket_lines.map { |line| line.scan(/\d+/).map(&:to_i) }
end

def get_scanning_error_rate(rules, nearby_tickets)
  nearby_tickets.flatten.reduce(0) do |sum, field|
    num_matching = rules.values.flatten.count do |range|
      range.cover?(field)
    end
    num_matching > 0 ? sum : sum + field
  end
end

def potential_valid_ticket?(rules, ticket)
  ticket.each do |field|
    num_matching = rules.values.flatten.count { |range| range.cover? (field) }
    return false if num_matching.zero?
  end
  true
end

def ticket_matches_rules(ranges, ticket)
  ticket.each_index do |field_index|
    valid_ranges = ranges[field_index]
    field_value = ticket[field_index]
    return false if valid_ranges.none? { |range| range.cover?(field_value) }
  end
  true
end

def field_fits_index(rules, field, index, nearby_tickets)
  valid_ranges = rules[field]
  nearby_tickets.all? do |ticket|
    valid_ranges.any? { |range| range.cover?(ticket[index]) } 
  end
end

def remove_impossible_fields(field_list, nearby_tickets, index, rules)
  field_list.select do |field|
    field_fits_index(rules, field, index, nearby_tickets)
  end
end

def find_perfect_ordering(possible_fields)
  field_indices = (0...possible_fields.size).sort_by { |field_index| possible_fields[field_index].size }
  processed = []
  field_indices.each do |index|
    processed << index
    field_to_remove = possible_fields[index].first
    possible_fields.each_index do |field_list_index|
      next if processed.include?(field_list_index)
      possible_fields[field_list_index].delete(field_to_remove)
    end
  end
  possible_fields.flatten
end

def validate(ordering, rules, nearby_tickets)
  ordering.each_index do |index|
    field = ordering[index]
    unless field_fits_index(rules, field, index, nearby_tickets)
      puts "This is wrong #{index}"
    end
  end
  true
end

# get data
rules = build_rules(input_file)
my_ticket = get_my_ticket(input_file)
nearby_tickets = get_nearby_tickets(input_file)
input_file.close
# remove all invalid tickets
nearby_tickets.delete_if { |ticket| !potential_valid_ticket?(rules, ticket) }
# build an array in which each item is an array of fields that may be
# valid for that index

possible_combinations = (0...my_ticket.size).map do |index|
  remove_impossible_fields(rules.keys, nearby_tickets, index, rules)
end
p possible_combinations
perfect_ordering = find_perfect_ordering(possible_combinations)
p perfect_ordering

fields = (0...perfect_ordering.size).select do |field_index|
  perfect_ordering[field_index].include?('departure')
end
product = fields.reduce(1) do |product, index|
  product * my_ticket[index]
end
puts product