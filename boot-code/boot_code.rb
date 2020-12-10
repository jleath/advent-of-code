# Given a sequence of boot-code instructions, determine the point at which
# a program would enter an infinite loop. If the program never enters
# an infinite loop, just report the final value of the accumulator

# Our boot code has three operations
# - jmp - jump to a new instruction using the argument as an offset
# - acc - add the argument to a global accumulator variable
# - nop - does nothing

# all three operations take a single signed integer

# Our input text file contains one instruction per line and is formatted
# like this:

# jmp -538
# acc +0
# nop -265

# we will assume that all jmp operations are valid

# We need to read the file, storing each line in an array named instructions.
# Then initialize another array of false values named executed. This array should
# have the same number of elements as our instructions array.
# Initialize an accumulator variable to 0
# Initialize a curr_instruction variable to 0
# while curr_instruction >= 0 and < instructions.size
#   return accumulator if executed[curr_instruction]
#   mark executed[curr_instruction] as true
#   split instructions[curr_instruction] into the opcode and its argument
#   if opcode is 'jmp' set curr_instruction = curr_instruction + argument
#   if opcode is 'acc' set accumulator = accumulator + argument and increment curr_instruction
#   otherwise, increment curr_instruction

def read_instructions(file_name)
  input_file = File.open(file_name, "r")
  instructions = input_file.readlines
  input_file.close
  instructions
end

def program_completed?(instruction_no, num_instructions)
  instruction_no == num_instructions
end

def get_accumulator_value(instructions)
  executed = [false] * instructions.size
  curr_instruction = 0
  accumulator = 0
  until program_completed?(curr_instruction, instructions.size)
    return nil if executed[curr_instruction]

    executed[curr_instruction] = true
    operation, argument = instructions[curr_instruction].split
    if operation == 'jmp'
      curr_instruction += argument.to_i
    elsif operation == 'acc'
      accumulator += argument.to_i
      curr_instruction += 1
    else
      curr_instruction += 1
    end
  end
  accumulator
end

def switch_jmp_nop(instructions, instruction_no)
  operation, argument = instructions[instruction_no].split
  instructions_copy = instructions.clone
  if operation == 'jmp'
    instructions_copy[instruction_no] = "nop #{argument}"
  elsif operation == 'nop'
    instructions_copy[instruction_no] = "jmp #{argument}"
  end
  instructions_copy
end

def corrected_program_result(instructions)
  instructions.each_index do |index|
    operation = instructions[index].split[0]
    if operation == 'jmp' || operation == 'nop'
      result = get_accumulator_value(switch_jmp_nop(instructions, index))
      return result unless result.nil?
    end
  end
  get_accumulator_value(instructions)
end

instructions = read_instructions('input.txt')
puts corrected_program_result(instructions)

