require 'rails_helper'

RSpec.describe "incidents/new", :type => :view do
  before(:each) do
    assign(:incident, Incident.new(
      :subject => "MyString",
      :description => "MyText",
      :topic => nil
    ))
  end

  it "renders new incident form" do
    render

    assert_select "form[action=?][method=?]", incidents_path, "post" do

      assert_select "input#incident_subject[name=?]", "incident[subject]"

      assert_select "textarea#incident_description[name=?]", "incident[description]"

      assert_select "input#incident_topic_id[name=?]", "incident[topic_id]"
    end
  end
end
