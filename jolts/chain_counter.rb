class ChainCounter
  def initialize(input_filename)
    @chain_hash = {}
    input_file = File.open(input_filename, 'r')
    @adapters = input_file.readlines.map { |rating| rating.chomp.to_i }.sort
    input_file.close
    @adapters.unshift(0)
    @adapters.push(@adapters.last + 3)
  end

  def get_diff_count(diff)
    (1...@adapters.size).reduce(0) do |count, index|
      @adapters[index] - @adapters[index - 1] == diff ? count + 1 : count
    end
  end

  def count_chains
    count(0)
  end

  private

  def count(last_rating)
    return 1 if @adapters.size - last_rating == 2

    index = last_rating + 1
    total_count = 0
    while valid_next_adapter?(@adapters[last_rating], @adapters[index])
      @chain_hash[index] = count(index) unless @chain_hash.key?(index)
      total_count += @chain_hash[index]
      index += 1
    end
    total_count
  end

  def valid_next_adapter?(curr_adapter, next_adapter)
    (1..3).cover?(next_adapter - curr_adapter)
  end
end

counter = ChainCounter.new('inputs.txt')
puts counter.get_diff_count(1) * counter.get_diff_count(3)
puts counter.count_chains
