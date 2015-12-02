require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Android

test_developer_id = 'Zynga'

def check_results(results)
  it 'should return valid results' do
    results.length.should == 24
    results[0][:title].should == "New Words With Friends"
  end
end

describe 'developer' do
  context 'Construction' do
    it 'should copy params' do
      dev = Developer.new(test_developer_id)
      dev.identifier.should == test_developer_id
    end

  end

  
end
