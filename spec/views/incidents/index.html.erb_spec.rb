require 'rails_helper'

RSpec.describe "incidents/index", :type => :view do
  before(:each) do
    assign(:incidents, [
      Incident.create!(
        :subject => "Subject",
        :description => "MyText",
        :topic => nil
      ),
      Incident.create!(
        :subject => "Subject",
        :description => "MyText",
        :topic => nil
      )
    ])
  end

  it "renders a list of incidents" do
    render
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
