require 'rails_helper'

RSpec.describe "incidents/edit", :type => :view do
  before(:each) do
    @incident = assign(:incident, Incident.create!(
      :subject => "MyString",
      :description => "MyText",
      :topic => nil
    ))
  end

  it "renders the edit incident form" do
    render

    assert_select "form[action=?][method=?]", incident_path(@incident), "post" do

      assert_select "input#incident_subject[name=?]", "incident[subject]"

      assert_select "textarea#incident_description[name=?]", "incident[description]"

      assert_select "input#incident_topic_id[name=?]", "incident[topic_id]"
    end
  end
end
