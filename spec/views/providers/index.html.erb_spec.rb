require 'rails_helper'

RSpec.describe "providers/index", :type => :view do
  before(:each) do
    assign(:providers, [
      Provider.create!(
        :type => "Type",
        :details => ""
      ),
      Provider.create!(
        :type => "Type",
        :details => ""
      )
    ])
  end

  it "renders a list of providers" do
    render
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
