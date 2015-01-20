require 'rails_helper'

RSpec.describe "notifiers/show", :type => :view do
  before(:each) do
    @notifier = assign(:notifier, Notifier.create!(
      :type => "Type",
      :settings => "MyText",
      :notify_after_sec => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end
