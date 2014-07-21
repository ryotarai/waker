require 'rails_helper'

RSpec.describe "incidents/edit", :type => :view do
  before(:each) do
    @incident = assign(:incident, Incident.create!(
      :description => "MyString",
      :details => ""
    ))
  end

  it "renders the edit incident form" do
    render

    assert_select "form[action=?][method=?]", incident_path(@incident), "post" do

      assert_select "input#incident_description[name=?]", "incident[description]"

      assert_select "input#incident_details[name=?]", "incident[details]"
    end
  end
end
