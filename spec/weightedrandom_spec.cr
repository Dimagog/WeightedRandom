require "./spec_helper"

describe WeightedRandom do
  it "Create" do
    r = WeightedRandom.new([1, 2])
    r.class.to_s.should eq "WeightedRandom::BiasedCoin(Int32)"
    r.next_choice.class.should eq Int32

    r = WeightedRandom.new([1, 1, 8])
    r.class.to_s.should eq "WeightedRandom::Indexed(Int32)"
    r.next_choice.class.should eq Int32

    r = WeightedRandom.new({"a" => 1, "b" => 2})
    r.class.to_s.should eq "WeightedRandom::Keyed(String)"
    r.next_choice.class.should eq String

    r = WeightedRandom.new({a: 1, b: 2, c: 3}.to_h)
    r.class.to_s.should eq "WeightedRandom::Keyed(Symbol)"
    r.next_choice.class.should eq Symbol
  end

  it "BiasedCoin" do
    r = WeightedRandom.new([1, 2])
    r.class.to_s.should eq "WeightedRandom::BiasedCoin(Int32)"
    res = [0, 0]
    10000.times do
      res[r.next_choice] += 1
    end
    (res[1]/res[0]).should be_close 2.0, 0.2
  end

  it "Indexed" do
    r = WeightedRandom.new([1, 2, 3])
    r.class.to_s.should eq "WeightedRandom::Indexed(Int32)"
    res = [0, 0, 0]
    10000.times do
      res[r.next_choice] += 1
    end
    (res[1]/res[0]).should be_close 2.0, 0.2
    (res[2]/res[0]).should be_close 3.0, 0.2
  end

  it "Keyed" do
    r = WeightedRandom.new({:a => 1, :b => 2})
    res = {:a => 0, :b => 0}
    10000.times do
      res[r.next_choice] += 1
    end
    (res[:b]/res[:a]).should be_close 2.0, 0.2
  end
end
