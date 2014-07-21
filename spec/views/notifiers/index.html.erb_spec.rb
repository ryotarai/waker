require 'rails_helper'

RSpec.describe "notifiers/index", :type => :view do
  before(:each) do
    assign(:notifiers, [
      Notifier.create!(
        :user => "User",
        :notify_after => 1,
        :type => "Type",
        :details => ""
      ),
      Notifier.create!(
        :user => "User",
        :notify_after => 1,
        :type => "Type",
        :details => ""
      )
    ])
  end

  it "renders a list of notifiers" do
    render
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
