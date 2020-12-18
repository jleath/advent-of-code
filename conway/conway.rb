# Need to represent a 3 dimensional array of cubes
# at the start, one slice of the array of cubes has a set of active cubes
# during each cycle, cubes will activate or deactivate according to the state of
# their neighbors.

# If a cube is active and exactly 2 or 3 of its neighbors are also active, 
# the cube remains active. Otherwise, the cube becomes inactive.

# If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes 
# active. Otherwise, the cube remains inactive.

class ConwayCube
  attr_reader :cubes
  def initialize
    @cubes = {}
  end

  def add_cube(w, x, y, z)
    id = create_id(w, x, y, z)
    @cubes[id] = @cubes[id] || :inactive
  end

  def activate_cube(w, x, y, z)
    id = create_id(w, x, y, z)
    @cubes[id] = :active
    neighbors(id).each do |neighbor_id|
      add_cube(*neighbor_id.split)
    end
  end

  def cube_exists?(id)
    @cubes.key?(id)
  end

  def deactivate_cube(w, x, y, z)
    id = create_id(w, x, y, z)
    @cubes[id] = :inactive
  end

  def active_cube?(id)
    return false if @cubes[id].nil?
    @cubes[id]== :active
  end

  def active_neighbors(id)
    neighbors(id).count { |neighbor_id| active_cube?(neighbor_id) }
  end

  def create_id(w, x, y, z)
    "#{w} #{x} #{y} #{z}"
  end

  def neighbors(id)
    w, x, y, z = id.split.map(&:to_i)
    all_combinations([w, x, y, z]) - [id] 
  end

  def all_combinations(params)
    first = params.first
    if params.size == 1
      return [(first-1).to_s, first.to_s, (first+1).to_s]
    else
      rest = all_combinations(params.slice(1, params.size - 1))
      (first-1..first+1).each_with_object([]) do |first_val, accumulator|
        rest.each { |rest_val| accumulator << "#{first_val} #{rest_val}" }
      end
    end
  end

  def update_cycle
    to_activate = []
    to_deactivate = []
    start_cubes = @cubes.keys
    start_cubes.each do |cube_id|
      if active_cube?(cube_id)
        to_deactivate << cube_id unless (2..3).cover?(active_neighbors(cube_id))
      else
        to_activate << cube_id if active_neighbors(cube_id) == 3
      end
    end
    to_activate.each { |cube_id| activate_cube(*cube_id.split.map(&:to_i)) }
    to_deactivate.each { |cube_id| deactivate_cube(*cube_id.split.map(&:to_i)) }
  end

  def count_active_cubes
    @cubes.values.reduce(0) do |count, cube_state|
      cube_state == :active ? count + 1 : count
    end
  end
end

conway = ConwayCube.new

input_file = File.open('input.txt')
input_lines = input_file.readlines.map(&:chomp)

input_lines.size.times do |y|
  curr_line = input_lines[y]
  curr_line.size.times do |x|
    conway.add_cube(0, x, y, 0)
    conway.activate_cube(0, x, y, 0) if curr_line[x] == '#'
  end
end

6.times { |_| conway.update_cycle }
puts conway.count_active_cubes