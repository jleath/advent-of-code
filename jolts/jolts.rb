# Given a list of joltage ratings for adapters you have, determine the
# chain of adapters that can be used to use every adapter to charge a
# phone.

# The phone's joltage rating is equal to the rating of the highest rated
# adapter plus 3

# Any given adapter can take an input 1-3 jolts lower than its rating.
# Treat the charging outlet as having a rating of 0

# Once you have the chain of adapters figured out, and determine the number
# of 1 jolt differences, and the number of 3 jolt differences
# return the product of these two numbers

# we need to start by determining which adapters can be used at each point
# in the chain. This implies some kind of treelike structure. It is possible
# that at any point in the chain, we may have to choose between multiple adapters
# and the choice of a particular adapter could lead to us using an adapter
# that must be used later in the chain, since we can only use the adapters one time each.

# First, we will read in the adapters and save the ratings in an array.
# From this we can calculate our phone's rating by adding 3 to the max rating

# we know the rating of the outlet is 0, so we'll start from there. This will
# be the first node in our tree.
# Then we will scan through the array of adapters, looking for ones that are
# between 1 and 3 jolts. For each adapter we find, we'll remove it from the list
# of adapters, and repeat the process, looking for adapters that are 1-3 jolts
# higher than our current adapter. We'll continue this process until we are either
# out of adapters, we have exceeded our phones joltage rating, or we have no
# suitable adapters that can be used next.

# If we have used all available adapters and we are 1-3 jolts below our phones
# rating, we've found a valid chain and can move on to the next step.
# Otherwise, we have to unwind the chain back to the last adapter decision
# and repeat this process. If we've run out of adapter options, we'll unwind back
# to the previous adapter decision.

def get_diff_product(adapter_ratings)
  i = 1
  one_diff = 0
  three_diff = 0
  while i < adapter_ratings.size
    one_diff += 1 if adapter_ratings[i] - adapter_ratings[i - 1] == 1
    three_diff += 1 if adapter_ratings[i] - adapter_ratings[i - 1] == 3
    i += 1
  end
  puts "one_diff -> #{one_diff}"
  puts "three_diff -> #{three_diff}"
  puts one_diff * three_diff
end

def valid_adapter(curr_rating, last_rating)
  (1..3).cover?(curr_rating - last_rating)
end

CHAIN_HASH = {}

# An array of [] has 1 chain
# An array of [x] has 1 chain
# An array of [x, y] has 2 potential chains
# An array of [x, y, z] has 
def count_chains(last_rating, adapters)
  return 1 if adapters.size == 1
  i = 0
  valid_adapter_indices = []
  while adapters[i] <= last_rating + 3
    valid_adapter_indices << i
    i += 1
  end
  results = valid_adapter_indices.map do |index|
    adapter = adapters[index]
    rest = adapters.slice(index + 1, adapters.size - (index + 1))
    if CHAIN_HASH.has_key?(rest)
      CHAIN_HASH[rest]
    else
      result = count_chains(adapter, rest)
      CHAIN_HASH[rest] = result
      result
    end
  end
  results.reduce(:+)
end

input_file = File.open('inputs.txt', 'r')
adapter_ratings = input_file.readlines.map { |rating| rating.chomp.to_i }.sort
input_file.close

adapter_ratings.unshift(0)
adapter_ratings.push(adapter_ratings.last + 3)

get_diff_product(adapter_ratings)
puts count_chains(0, adapter_ratings.slice(1, adapter_ratings.size - 1))