def evaluate(tokens)
  puts "Evaluating #{tokens}"
  stack = []
  until tokens.empty?
    token = tokens.shift
    if token.match(/^\d+$/)
      stack.push(token.to_i)
    elsif token == '+'
      stack.push(stack.pop.send(token, evaluate(subexpression!(tokens))))
    elsif token == '*' || token == '('
      stack.push(evaluate(subexpression!(['('] + tokens)))
    end
  end
  p stack
  stack.reduce(&:*)
end

def subexpression!(token_array)
  first_token = token_array[0]
  subtokens = []
  if first_token.match(/^\d+$/)
    return [token_array.shift]
  elsif first_token == '('
    token_array.shift
    num_openers = 1
    until num_openers == 0
      if token_array[0] == '('
        num_openers += 1
        subtokens.push(token_array.shift)
      elsif token_array[0] == ')'
        num_openers -= 1
        if num_openers > 0
          subtokens.push(token_array.shift)
        else
          token_array.shift
        end
      else
        subtokens.push(token_array.shift)
      end
    end
    return subtokens
  end
end

input_file = File.open('small_input.txt','r')
expressions = input_file.readlines.map(&:chomp)

puts expressions.reduce(0) { |total, expression| total + evaluate(expression.gsub(' ', '').split('')) }