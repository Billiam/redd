RSpec.describe Redd::Clients::Unauthenticated::Stream do
  describe "::BoundedOrderedSet" do
    let(:bset) { Redd::Clients::Unauthenticated::Stream::QueueSet }

    it "has the correct limit" do
      instance = bset.new(3)
      expect(instance.limit).to eq(3)
    end

    it "contains the correct elements that were added" do
      instance = bset.new(3)
      instance.push(5, 6, 7)
      expect(instance).to contain_exactly(5, 6, 7)
    end

    it "gets rid of the oldest element after the limit is reached" do
      instance = bset.new(3)
      instance.push(5).push(6, 7, 8)
      expect(instance).to contain_exactly(6, 7, 8)
      expect(instance).to_not include(5)
    end
  end
end
