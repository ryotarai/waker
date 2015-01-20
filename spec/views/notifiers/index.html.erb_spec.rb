require 'rails_helper'

RSpec.describe "notifiers/index", :type => :view do
  before(:each) do
    assign(:notifiers, [
      Notifier.create!(
        :type => "Type",
        :settings => "MyText",
        :notify_after_sec => 1
      ),
      Notifier.create!(
        :type => "Type",
        :settings => "MyText",
        :notify_after_sec => 1
      )
    ])
  end

  it "renders a list of notifiers" do
    render
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
