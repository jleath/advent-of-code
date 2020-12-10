class ChainCounter
  attr_reader :adapters

  def initialize(input_filename)
    @chain_hash = {}
    input_file = File.open(input_filename, 'r')
    @adapters = input_file.readlines.map { |rating| rating.chomp.to_i }.sort
    input_file.close
    @adapters.unshift(0)
    @phone_rating = @adapters.last + 3
    @adapters.push(@phone_rating)
  end

  def get_diff_count(n)
    (1...@adapters.size).reduce(0) do |count, index|
      if @adapters[index] - @adapters[index - 1] == n
        count + 1
      else
        count
      end
    end
  end

  def count_chains
    count(0, @adapters.slice(1, @adapters.size - 1))
  end

  private

  def count(last_rating, adapters)
    return 1 if adapters.size == 1

    valid_adapter_indices = adapters.each_index.select do |index|
      valid_next_adapter?(last_rating, adapters[index])
    end
    valid_adapter_indices.reduce(0) do |count, index|
      remaining_adapters = adapters.slice(index + 1, adapters.size - (index + 1))
      if @chain_hash.has_key?(remaining_adapters)
        count + @chain_hash[remaining_adapters]
      else
        result = count(adapters[index], remaining_adapters)
        @chain_hash[remaining_adapters] = result
        count + result
      end
    end
  end

  def valid_next_adapter?(curr_adapter, next_adapter)
    (1..3).cover?(next_adapter - curr_adapter)
  end
end

counter = ChainCounter.new('inputs.txt')
puts counter.get_diff_count(1) * counter.get_diff_count(3)
puts counter.count_chains