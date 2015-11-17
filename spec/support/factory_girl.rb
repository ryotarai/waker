RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      FactoryGirl.lint
    ensure
      DatabaseRewinder.clean_all
    end
  end
end
