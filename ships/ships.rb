# Latitude represents the position on the north/south
# axis
# longitude represents the position on the east/west
# axis
class Waypoint
  attr_reader :latitude, :longitude

  DEFAULT_LATITUDE = 1
  DEFAULT_LONGITUDE = 10

  def initialize
    @latitude = DEFAULT_LATITUDE
    @longitude = DEFAULT_LONGITUDE
  end

  def command(operation, value)
    if %w(L R).include?(operation)
      rotate(operation, value)
    else
      move(operation, value)
    end
  end

  def rotate(direction, amount)
    while amount > 0
      direction == 'R' ? rotate_right : rotate_left
      amount -= 90
    end
  end

  private

  def move(direction, amount)
    if direction == 'N'
      @latitude += amount
    elsif direction == 'S'
      @latitude -= amount
    elsif direction == 'E'
      @longitude += amount
    elsif direction == 'W'
      @longitude -= amount
    end
  end

  def rotate_left
    @latitude, @longitude = @longitude, -@latitude
  end

  def rotate_right
    @latitude, @longitude = -@longitude, @latitude
  end
end

class Ship
  def initialize
    @latitude = 0
    @longitude = 0
    @waypoint = Waypoint.new
  end

  def command(operation, value)
    if operation == 'F'
      move_to_waypoint(value)
    else
      @waypoint.command(operation, value)
    end
  end

  def manhattan_distance
    @latitude.abs + @longitude.abs
  end

  private

  def move_to_waypoint(num_times)
    @longitude += @waypoint.longitude * num_times
    @latitude += @waypoint.latitude * num_times
  end
end