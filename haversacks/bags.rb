rule_file = File.open('rules.txt', 'r')
rule_text = rule_file.read.gsub("\n", "")
rule_file.close

rules = Hash.new

def split_rule_text(rule_text)
  rule_text.gsub(/\s?bag[s]*\s?/, '').chomp.split('contain ')
end

rule_text.split('.').each do |rule_desc|
  rule_components = split_rule_text(rule_desc)
  bag_type = rule_components[0]
  can_contain = {}
  if rule_components[1] == "no other"
    rules[bag_type] = can_contain
    next
  end

  rule_components[1].split(', ').each do |bag_info|
    bag_info = bag_info.split
    required_num = bag_info[0]
    bag_desc = bag_info.slice(1, bag_info.size - 1).join(' ')
    can_contain[bag_desc] = required_num.to_i
  end

  rules[bag_type] = can_contain
end

our_bag = "shiny gold"

def count_possible_bags(inner_bag, rules)
  rules.keys.reduce(0) do |count, enclosing_bag|
    can_contain?(enclosing_bag, inner_bag, rules) ? count + 1 : count
  end
end

def can_contain?(enclosing_bag, inner_bag, rules)
  possible_bags = rules[enclosing_bag].keys
  return true if possible_bags.any? { |bag| bag == inner_bag }
  return true if possible_bags.any? do |bag| 
    can_contain?(bag, inner_bag, rules)
  end
  false
end

def total_bags_required(enclosing_bag, rules)
  inner_bags = rules[enclosing_bag]
  inner_bags.keys.reduce(1) do |count, inner_bag|
    count + total_bags_required(inner_bag, rules) * inner_bags[inner_bag]
  end
end

puts count_possible_bags(our_bag, rules)
puts total_bags_required(our_bag, rules) - 1