class DockingEncoder
  attr_writer :mask

  def initialize
    @memory = Hash.new
  end

  def sum_memory
    @memory.values.sum
  end

  def update_address(address, value)
    bin_string = convert_to_bin(value)
    masked = apply_bitmask(bin_string)
    @memory[address] = convert_to_int(masked)
  end

  def update(address, value)
    addresses = apply_mask_to_address(address)
    addresses.each { |address| @memory[address] = value }
  end

  private
  attr_reader :mask

  def convert_to_int(bin_string)
    bin_string.chars.reduce(0) do |value, bin_char|
      (value * 2) + bin_char.to_i
    end
  end

  def apply_bitmask(bin_string)
    mask.chars.each_index.reduce('') do |result, mask_index|
      if mask[mask_index] == 'X'
        result << bin_string[mask_index]
      else
        result << mask[mask_index]
      end
      result
    end
  end

  def apply_mask_to_address(address)
    address_bin = convert_to_bin(address)
    mask.chars.each_index do |mask_index|
      address_bin[mask_index] = '1' if mask[mask_index] == '1'
    end
    floating = mask.chars.each_index.reduce([]) do |indices, char_index|
      mask[char_index] == 'X' ? indices + [char_index] : indices
    end
    construct_addresses(floating, address_bin)
  end

  def construct_addresses(floating_indices, address_bin)
    return address_bin if floating_indices.size == 0

    first_index = floating_indices[0]
    chars = address_bin.chars
    chars[first_index] = '1'
    first_option = chars.join('')
    chars[first_index] = '0'
    second_option = chars.join('')
    rest_of_indices = floating_indices.slice(1, floating_indices.size - 1)

    [construct_addresses(rest_of_indices, first_option),
     construct_addresses(rest_of_indices, second_option)].flatten
  end

  def convert_to_bin(value)
    bin_string = ''
    while value > 0
      bin_string = (value % 2).to_s + bin_string
      value = value / 2
    end
    num_zeros = 36 - bin_string.size
    ('0' * num_zeros) + bin_string
  end
end

def extract_address(instruction)
  address_start = (instruction =~ /\[/) + 1
  address_length = (instruction =~ /\]/) - address_start
  instruction.slice(address_start, address_length)
end

def build_instructions(input_file)
  instruction_text = input_file.readlines.map(&:chomp)
  instruction_text.reduce([]) do |instructions, text|
    instruction = []
    if text.slice(0, 4) == 'mask'
      instruction << :mask
      instruction << text.split(' = ')[1]
    else
      instruction << extract_address(text).to_i
      instruction << text.split(' = ')[1].to_i
    end
    instructions << instruction
  end
end

input_file = File.open('input.txt', 'r')
instructions = build_instructions(input_file)
input_file.close

encoder = DockingEncoder.new

instructions.each do |instruction|
  if instruction[0] == :mask
    encoder.mask = instruction[1]
  else
    encoder.update(*instruction)
  end
end

puts encoder.sum_memory