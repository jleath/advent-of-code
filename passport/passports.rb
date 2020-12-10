REQUIRED_FIELDS = %w(byr iyr eyr hgt hcl ecl pid).sort
YEAR_REGEX = /\d{4}/
HEIGHT_RANGE_CM = (150..193)
HEIGHT_RANGE_IN = (59..76)

def valid_key?(key)
  %w(byr iyr eyr hgt hcl ecl pid cid).include?(key)
end

def valid_year?(year_string, min_year, max_year)
  !!year_string.match(YEAR_REGEX) && (min_year..max_year).cover?(year_string.to_i)
end

def valid_height?(value)
  unit = value.slice(value.size - 2, 2)
  measure = value.slice(0, value.size - 2).to_i

  case unit
  when 'cm' then (HEIGHT_RANGE_CM).cover?(measure)
  when 'in' then (HEIGHT_RANGE_IN).cover?(measure)
  else false
  end
end

def valid_hair_color?(value)
  !!value.match(/#([a-z]|[0-9]){6}/)
end

def valid_eye_color?(value)
  %w(amb blu brn gry grn hzl oth).include?(value)
end

def valid_passport_id?(value)
  !!value.match(/\d{9}/)
end

def valid?(key, value)
  case key
  when 'byr'
    valid_year?(value, 1920, 2002)
  when 'iyr'
    valid_year?(value, 2010, 2020)
  when 'eyr'
    valid_year?(value, 2020, 2030)
  when 'hgt'
    valid_height?(value)
  when 'hcl'
    valid_hair_color?(value)
  when 'ecl'
    valid_eye_color?(value)
  when 'pid'
    valid_passport_id?(value)
  else
    true
  end
end

passport_data_lines = File.open('input.txt', 'r').readlines.map(&:strip)

passports = []
current_data = Hash.new

passport_data_lines.each do |line|
  if line.empty?
    passports << current_data unless current_data.empty?
    current_data = Hash.new
  else
    line.split.each do |pair|
      key, value = pair.split(':')
      current_data[key] = value if key != 'cid' && valid?(key, value)
    end
  end
end

passports << current_data unless current_data.empty?

valid_passports = []

passports.each do |passport_data|
  keys = passport_data.keys.sort
  valid_passports << passport_data if keys == REQUIRED_FIELDS
end

valid_passports.each do |pass|
  p pass.sort
end

puts "#{valid_passports.size} valid passports."