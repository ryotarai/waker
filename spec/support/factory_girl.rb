RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    begin
      FactoryBot.lint
    ensure
      DatabaseRewinder.clean_all
    end
  end
end
