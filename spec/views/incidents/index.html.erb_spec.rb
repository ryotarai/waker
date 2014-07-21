require 'rails_helper'

RSpec.describe "incidents/index", :type => :view do
  before(:each) do
    assign(:incidents, [
      Incident.create!(
        :description => "Description",
        :details => ""
      ),
      Incident.create!(
        :description => "Description",
        :details => ""
      )
    ])
  end

  it "renders a list of incidents" do
    render
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
