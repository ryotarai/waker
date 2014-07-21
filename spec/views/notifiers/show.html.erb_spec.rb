require 'rails_helper'

RSpec.describe "notifiers/show", :type => :view do
  before(:each) do
    @notifier = assign(:notifier, Notifier.create!(
      :user => "User",
      :notify_after => 1,
      :type => "Type",
      :details => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/User/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(//)
  end
end
