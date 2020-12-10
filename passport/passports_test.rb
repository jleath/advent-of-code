require 'minitest/autorun'
require 'minitest/reporters'

require_relative 'passports'

Minitest::Reporters.use!

class PassportsTest < Minitest::Test
  def test_valid_year
    assert_equal(true, valid_year?('2000', 2000, 2010))
    assert_equal(true, valid_year?('2000', 1990, 2000))
    assert_equal(true, valid_year?('2004', 1990, 2010))
    assert_equal(true, valid_year?('2004', 2004, 2004))
    assert_equal(false, valid_year?('200', 1, 1000))
    assert_equal(false, valid_year?('', 1, 1000))
    assert_equal(false, valid_year?('2010', 2000, 2005))
  end

  def test_valid_height
    assert_equal(true, valid_height?('150cm'))
    assert_equal(true, valid_height?('193cm'))
    assert_equal(true, valid_height?('160cm'))
    assert_equal(true, valid_height?('59in'))
    assert_equal(true, valid_height?('76in'))
    assert_equal(true, valid_height?('65in'))
    assert_equal(false, valid_height?('150'))
    assert_equal(false, valid_height?(''))
    assert_equal(false, valid_height?('149cm'))
    assert_equal(false, valid_height?('194cm'))
    assert_equal(false, valid_height?('58in'))
    assert_equal(false, valid_height?('77in'))
    assert_equal(false, valid_height?('77 in'))
  end

  def test_valid_hair_color
    assert_equal(true, valid_hair_color?('#12abab'))
    assert_equal(true, valid_hair_color?('#123456'))
    assert_equal(true, valid_hair_color?('#000000'))
    assert_equal(true, valid_hair_color?('#ffffff'))
    assert_equal(false, valid_hair_color?('ffffff'))
    assert_equal(false, valid_hair_color?('012345'))
    assert_equal(false, valid_hair_color?(''))
    assert_equal(false, valid_hair_color?('#012ABc'))
    assert_equal(false, valid_hair_color?('#'))
  end

  def test_valid_passport_id
    assert_equal(true, valid_passport_id?('000012345'))
    assert_equal(true, valid_passport_id?('123456789'))
    assert_equal(true, valid_passport_id?('999999999'))
    assert_equal(true, valid_passport_id?('000000000'))
    assert_equal(false, valid_passport_id?(''))
    assert_equal(false, valid_passport_id?('00000000b'))
    assert_equal(false, valid_passport_id?('99999999'))
    assert_equal(false, valid_passport_id?('abcdefghi'))
  end
end