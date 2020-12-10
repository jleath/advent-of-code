# input file uses a-z to represent each of the 26 yes-or-no questions
# each line represents one person's answers to those questions, if the 
# letter for a question is present, it means that the person responded
# yes to that question

# Groups are separated by a blank line.

# Algorithm

# Read the input file into an array, one line per item
# initialize a groups array
# initialize a curr_group array

# iterate through input array one line at a time
#   if current line is blank and curr_group array is not empty
#     append curr_group array to groups array
#   otherwise
#     append the current line to curr_group

# initialize sum to 0

# iterate through groups array one group at a time
#   join the strings of each groups subarray together
#   remove duplicates from joined string
#   add length of resulting joined string to sum

# report sum

input_lines = File.open('input.txt', 'r').readlines.map(&:strip)

groups = []
curr_group = []

input_lines.each do |line|
  if line == '' && !curr_group.empty?
    groups << curr_group
    curr_group = []
  else
    curr_group << line
  end
end

groups << curr_group unless curr_group.empty?

sum = 0

groups.each do |group|
  ('a'..'z').each do |question_code|
    sum += 1 if group.all? { |responses| responses.include?(question_code) }
  end
end

puts sum