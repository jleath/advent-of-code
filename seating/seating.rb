NUM_ROWS = 128
NUM_COLUMNS = 8

def get_row_number(partitions)
  min = 0
  max = NUM_ROWS - 1
  mid = min + (max - min) / 2
  partitions.chars.each do |partition_code|
    if partition_code == 'F'
      max = mid
    else
      min = mid + 1
    end
    mid = min + (max - min) / 2
  end
  min
end

def get_col_number(partitions)
  min = 0
  max = NUM_COLUMNS - 1
  mid = min + (max - min) / 2
  partitions.chars.each do |partition_code|
    if partition_code == 'L'
      max = mid
    else
      min = mid + 1
    end
    mid = min + (max - min) / 2
  end
  min
end

def calc_seat_number(partition_string)
  row = get_row_number(partition_string.slice(0, 7))
  col = get_col_number(partition_string.slice(7, 3))
  (row * NUM_COLUMNS) + col
end

seat_lines = File.open('input.txt', 'r').readlines.map(&:strip)

seats = []

seat_lines.each { |line| seats << calc_seat_number(line) }

(0..1023).each do |seat_number|
  next if seats.include?(seat_number)

  if seats.include?(seat_number - 1) && seats.include?(seat_number + 1)
    puts "#{seat_number}"
  end
end