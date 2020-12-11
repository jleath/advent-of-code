class Seating
  OCCUPIED_MARKER = '#'
  UNOCCUPIED_MARKER = 'L'
  FLOOR_MARKER = '.'
  attr_reader :seats

  def initialize(filename)
    @seats = read_input(filename)
  end

  def update
    new_state = []
    y = 0
    while y < @seats.size
      row = ''
      x = 0
      while x < @seats[0].size
        row << update_seat(x, y)
        x += 1
      end
      new_state << row
      y += 1
    end
    @seats = new_state
  end

  def update_seat(x, y)
    return FLOOR_MARKER if floor?(x, y)
    visible_seats = visible(x, y)
    if occupied?(x, y) && visible_seats.count { |coords| occupied?(*coords) } >= 5
      UNOCCUPIED_MARKER
    elsif unoccupied?(x, y) && visible_seats.count { |coords| occupied?(*coords) } == 0
      OCCUPIED_MARKER
    else
      seat_state(x, y)
    end
  end

  def num_occupied_seats
    count = 0
    (0...@seats[0].size).each do |x_index|
      (0...@seats.size).each do |y_index|
        count += occupied?(x_index, y_index) ? 1 : 0
      end
    end
    count
  end

  def seat_state(x, y)
    @seats[y][x]
  end

  def occupied?(x, y)
    seat_state(x, y) == OCCUPIED_MARKER
  end

  def unoccupied?(x, y)
    seat_state(x, y) == UNOCCUPIED_MARKER || floor?(x, y)
  end

  def floor?(x, y)
    seat_state(x, y) == FLOOR_MARKER
  end

  def find_closest(x, y)
    x, y = yield(x, y)
    while x >= 0 && x < @seats[0].size && y >= 0 && y < @seats.size
      return [x, y] unless floor?(x, y)
      x, y = yield(x, y)
    end
    []
  end

  def visible(x, y)
    possible_positions = []
    possible_positions << find_closest(x, y) { |x, y| [x, y-1] }
    possible_positions << find_closest(x, y) { |x, y| [x, y+1] }
    possible_positions << find_closest(x, y) { |x, y| [x-1, y] }
    possible_positions << find_closest(x, y) { |x, y| [x+1, y] }
    possible_positions << find_closest(x, y) { |x, y| [x-1, y-1] }
    possible_positions << find_closest(x, y) { |x, y| [x-1, y+1] }
    possible_positions << find_closest(x, y) { |x, y| [x+1, y-1] }
    possible_positions << find_closest(x, y) { |x, y| [x+1, y+1] }
    possible_positions.reject(&:empty?)
  end

  private

  def read_input(filename)
    input_file = File.open(filename, 'r')
    result = input_file.readlines.map(&:chomp)
    input_file.close
    result
  end
end

seating = Seating.new('input.txt')
prev_state = seating.seats
loop do
  seating.update
  break if seating.seats == prev_state
  prev_state = seating.seats
end
puts seating.num_occupied_seats