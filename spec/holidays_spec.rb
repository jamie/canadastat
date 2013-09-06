require './lib/holidays'

describe Thanksgiving do
  it 'should be correct in 2012' do
    Thanksgiving.new(2012).to_s.should eq("2012-10-08 Thanksgiving")
  end
  it 'should be correct in 2013' do
    Thanksgiving.new(2013).to_s.should eq("2013-10-14 Thanksgiving")
  end
end
