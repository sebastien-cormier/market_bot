require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Android

test_id = :topselling_paid
test_category = :arcade

def check_results(results)
  it 'should return valid results' do
    results.length.should == 96
    results.each do |app|
      app.keys.sort.should == [:developer, :icon_url, :market_id, :market_url, :price_usd, :stars, :title]
      app[:market_url].should == App.new(app[:market_id]).market_url
      app[:price_usd].should =~ /^\$\d+\.\d{2}$/
      app[:stars].to_f.should > 0.0
      app[:stars].to_f.should <= 5.0
    end
  end

  it 'should have the top ranking app with valid details' do
    results.first[:developer].should == 'Mojang'
    results.first[:market_id].should == 'com.mojang.minecraftpe'
    results.first[:market_url].should == 'https://play.google.com/store/apps/details?id=com.mojang.minecraftpe&hl=en'
    results.first[:price_usd].should == '$6.99'
    results.first[:stars].should == '4.5'
    results.first[:title].should == "Minecraft - Pocket Edition"
  end

end

describe 'Leaderboard' do
  context 'Construction' do
    it 'should copy params' do
      lb =MarketBot::Android::Leaderboard.new(test_id, test_category)
      lb.identifier.should == test_id
      lb.category.should == test_category
    end

    it 'should have an optional category parameter' do
      lb = MarketBot::Android::Leaderboard.new(test_id)
      lb.identifier.should == test_id
      lb.category.should == nil
    end
  end

  it 'should generate URLs using min and max page ranges' do
    lb = MarketBot::Android::Leaderboard.new(test_id, test_category)
    urls = lb.market_urls(:min_page => 1, :max_page => 3)
    urls.should == [
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=0&gl=us&num=24&hl=en',
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=24&gl=us&num=24&hl=en',
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=48&gl=us&num=24&hl=en'
    ]
  end

  it 'should generate URLs using country' do
    lb = MarketBot::Android::Leaderboard.new(test_id, test_category)
    urls = lb.market_urls(:min_page => 1, :max_page => 3, :country => 'au')
    urls.should == [
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=0&gl=au&num=24&hl=en',
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=24&gl=au&num=24&hl=en',
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=48&gl=au&num=24&hl=en'
    ]
  end


  it 'should convert ranks to market leaderboard pages (24 apps per page)' do
    app = MarketBot::Android::Leaderboard.new(test_id, test_category)
    app.rank_to_page(1).should == 1
    app.rank_to_page(24).should == 1
    app.rank_to_page(25).should == 2
    app.rank_to_page(48).should == 2
  end

end
