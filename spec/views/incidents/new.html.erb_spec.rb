require 'rails_helper'

RSpec.describe "incidents/new", :type => :view do
  before(:each) do
    assign(:incident, Incident.new(
      :description => "MyString",
      :details => ""
    ))
  end

  it "renders new incident form" do
    render

    assert_select "form[action=?][method=?]", incidents_path, "post" do

      assert_select "input#incident_description[name=?]", "incident[description]"

      assert_select "input#incident_details[name=?]", "incident[details]"
    end
  end
end
