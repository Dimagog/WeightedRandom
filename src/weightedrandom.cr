module WeightedRandom
  VERSION = "0.1.0"

  abstract class WeightedRandom(K)
    abstract def next_choice : K
  end

  private def self.is_int(x : Int)
  end

  def self.indexed(weights : Array(T)) : WeightedRandom(Int32) forall T
    is_int(weights[1]) # this is both type and range check

    if weights.size == 2
      BiasedCoin.new weights[0], weights[1]
    else
      Indexed.new weights
    end
  end

  def self.keyed(weights : Hash(K, V)) : WeightedRandom(K) forall K, V
    Keyed.new weights
  end

  def self.new(weights : Array(T)) : WeightedRandom(Int32) forall T
    self.indexed weights
  end

  def self.new(weights : Hash(K, V)) : WeightedRandom(K) forall K, V
    self.keyed weights
  end

  private class BiasedCoin(T) < WeightedRandom(Int32)
    @total : T

    def initialize(@w1 : T, w2 : T)
      @total = w1 + w2
    end

    def next_choice : Int32
      Random.rand(@total) < @w1 ? 0 : 1
    end
  end

  private class Indexed(T) < WeightedRandom(Int32)
    @weights : Array(T)
    @aliases : Array(Int32)
    @avg : T

    def initialize(weights input_weights : Array(T))
      @avg = input_weights.sum # average is just a sum because later we multiply all weights by cnt
      cnt = input_weights.size
      @weights = input_weights.map { |x| x * cnt }
      @aliases = Array.new(cnt, -1)
      small = [] of Int32
      big = [] of Int32
      @weights.each_with_index do |x, i|
        if x < @avg
          small << i
        else
          big << i
        end
      end
      # puts @avg, cnt, @weights, small, big
      while !small.empty?
        small_i = small.pop
        big_i = big.last
        @aliases[small_i] = big_i
        @weights[big_i] -= @avg - @weights[small_i]
        if @weights[big_i] < @avg
          small << big.pop
        end
      end
      # puts @weights, @aliases
    end

    def next_choice : Int32
      col = Random.rand(@weights.size)
      Random.rand(@avg) < @weights[col] ? col : @aliases[col]
    end
  end

  private class Keyed(K) < WeightedRandom(K)
    @indexed : WeightedRandom(Int32)
    @keys : Array(K)

    def initialize(weights : Hash(K, V)) forall V
      @indexed = ::WeightedRandom.indexed(weights.values)
      @keys = weights.keys
    end

    def next_choice : K
      @keys[@indexed.next_choice]
    end
  end
end
