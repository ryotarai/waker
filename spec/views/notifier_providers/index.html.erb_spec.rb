require 'rails_helper'

RSpec.describe "notifier_providers/index", :type => :view do
  before(:each) do
    assign(:notifier_providers, [
      NotifierProvider.create!(
        :name => "Name",
        :kind => 1,
        :settings => "MyText"
      ),
      NotifierProvider.create!(
        :name => "Name",
        :kind => 1,
        :settings => "MyText"
      )
    ])
  end

  it "renders a list of notifier_providers" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
