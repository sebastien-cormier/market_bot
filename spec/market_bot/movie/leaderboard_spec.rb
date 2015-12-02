require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Movie

test_id = :topselling_paid
test_category = :comedy

def stub_hydra(hydra)
  test_src_page = read_file(File.dirname(__FILE__), 'data', 'leaderboard-movies_comedy_topselling_paid.txt')
  #response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_page)
  url = 'https://play.google.com/store/movies/category/COMEDY/collection/topselling_paid?start=0&gl=us&num=24&hl=en'
  #Typhoeus.stub(url).and_return(response)
end

def check_results(results)
  it 'should have the top ranking app with valid details' do
    results.first[:genre].should == 'Comedy'
    results.first[:stars].should == '3.6'
    results.first[:title].should == 'Dear White People'
    results.first[:price_usd].should == '$4.99'
    results.first[:market_id].should == 'vRpjPMDxpg0'
    results.first[:market_url].should == 'https://play.google.com/store/movies/details/Dear_White_People?id=vRpjPMDxpg0&hl=en'
  end
end

describe 'Leaderboard' do
  context 'Construction' do
    it 'should copy params' do
      lb = MarketBot::Movie::Leaderboard.new(test_id, test_category)
      lb.identifier.should == test_id
      lb.category.should == test_category
    end

    it 'should have an optional category parameter' do
      lb = MarketBot::Movie::Leaderboard.new(test_id)
      lb.identifier.should == test_id
      lb.category.should == nil
    end
  end

end
