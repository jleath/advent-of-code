# # Open file
# password_file = File.open("input.txt", "r")

# # Read each line
# password_lines = password_file.readlines

# # initialize a bad_passwords count
# good_passwords = 0

# # for each line
# password_lines.each do |line|
# #   split line into lowest, highest, required_char, and password
#   tokens = line.split
#   lowest = tokens[0].split('-')[0].to_i
#   highest = tokens[0].split('-')[1].to_i
#   required_char = tokens[1][0]
#   password = tokens[2]
# #   if required_char is not in password at least lowest but no more than highest times, increment bad_passwords
#   if (lowest..highest).cover?(password.count(required_char))
#     good_passwords += 1 # unless (lowest..highest).cover?(password.count(required_char))
#     puts "lowest->#{lowest} highest->#{highest} required_char->#{required_char} password->#{password} count->#{password.count(required_char)}"
#   end
# end
# # puts bad_passwords
# puts "Number of good passwords: #{good_passwords}"

# Open file
password_file = File.open("input.txt", "r")

# Read each line
password_lines = password_file.readlines

# initialize a bad_passwords count
good_passwords = 0

# for each line
password_lines.each do |line|
#   split line into lowest, highest, required_char, and password
  tokens = line.split
  first_position = tokens[0].split('-')[0].to_i - 1
  second_position = tokens[0].split('-')[1].to_i - 1
  required_char = tokens[1][0]
  password = tokens[2]
  valid_positions = 0
  valid_positions += 1 if password[first_position] == required_char
  valid_positions += 1 if password[second_position] == required_char
#   if required_char is not in password at least lowest but no more than highest times, increment bad_passwords
  if valid_positions == 1
    good_passwords += 1 
  end
end
# puts bad_passwords
puts "Number of good passwords: #{good_passwords}"