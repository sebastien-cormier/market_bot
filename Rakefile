require 'bundler/gem_tasks'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

desc 'Start an IRB console with Workers loaded'
task :console do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

  require 'market_bot'
  require 'irb'

  ARGV.clear

  IRB.start
end

namespace :spec do
  namespace :data do
    
    
  end
end

namespace :benchmark do
  task :android do
    require 'market_bot'
    require 'benchmark'

    hydra = Typhoeus::Hydra.new(:max_concurrency => 20)

    leaderboard = nil
    leaderboard_ms = Benchmark.realtime {
      leaderboard = MarketBot::Android::Leaderboard.new(:apps_topselling_paid, nil, :hydra => hydra)
      leaderboard.update
    }

    puts '----------------------------------------------------'
    puts 'Benchmark Leaderboard: Top Selling Paid Apps'
    puts '----------------------------------------------------'
    puts "app count: #{leaderboard.results.length}"
    puts "time: #{leaderboard_ms.round(3)} seconds"
    puts

    apps = nil
    apps_ms = Benchmark.realtime {
      apps = leaderboard.results.map{ |r| MarketBot::Android::App.new(r[:market_id], :hydra => hydra).enqueue_update }
      hydra.run
    }

    puts '----------------------------------------------------'
    puts 'Benchmark Apps: top Selling Paid Apps'
    puts '----------------------------------------------------'
    puts "app count: #{apps.length}"
    puts "time: #{apps_ms.round(3)} seconds"
  end
end
