require 'minitest/autorun'
require 'minitest/reporters'

require_relative 'seating'

Minitest::Reporters.use!

class SeatingTest < Minitest::Test
  def test_constructor
    seating = Seating.new('small_input.txt')
    expected = ['L.LL.LL.LL',
                'LLLLLLL.LL',
                'L.L.L..L..',
                'LLLL.LL.LL',
                'L.LL.LL.LL',
                'L.LLLLL.LL',
                '..L.L.....',
                'LLLLLLLLLL',
                'L.LLLLLL.L',
                'L.LLLLL.LL']
    assert_equal(expected, seating.seats)
  end

  def test_state_methods
    seating = Seating.new('small_input.txt')
    assert_equal(true, seating.occupied?(2, 1))
    assert_equal(true, seating.occupied?(0, 0))
    assert_equal(false, seating.occupied?(1, 0))
    assert_equal(true, seating.unoccupied?(1, 0))
    assert_equal(true, seating.unoccupied?(9, 2))
    assert_equal(false, seating.unoccupied?(9, 9))
    assert_equal(true, seating.floor?(1, 0))
    assert_equal(true, seating.floor?(7, 0))
    assert_equal(true, seating.floor?(1, 9))
    assert_equal(false, seating.floor?(9, 9))
  end

  def test_adjacent
    seating = Seating.new('small_input.txt')
    expected_3_4 = [[2, 3], [3, 3], [4, 3],
                    [2, 4], [4, 4],
                    [2, 5], [3, 5], [4, 5]].sort
    assert_equal(expected_3_4, seating.adjacent(3, 4).sort)
    expected_0_0 = [[1, 0], [0, 1], [1, 1]].sort
    assert_equal(expected_0_0, seating.adjacent(0, 0).sort)
    expected_9_9 = [[9, 8], [8, 9], [8, 8]].sort
    assert_equal(expected_9_9, seating.adjacent(9, 9).sort)
    expected_0_4 = [[0, 3], [1, 3], [1, 4], [0, 5], [1, 5]].sort
    assert_equal(expected_0_4, seating.adjacent(0, 4).sort)
    expected_9_4 = [[9, 3], [8, 4], [8, 3], [8, 5], [9, 5]].sort
    assert_equal(expected_9_4, seating.adjacent(9, 4).sort)
  end
end