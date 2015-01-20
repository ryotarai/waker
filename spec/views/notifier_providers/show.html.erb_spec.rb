require 'rails_helper'

RSpec.describe "notifier_providers/show", :type => :view do
  before(:each) do
    @notifier_provider = assign(:notifier_provider, NotifierProvider.create!(
      :name => "Name",
      :kind => 1,
      :settings => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
  end
end
