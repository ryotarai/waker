require 'rails_helper'

RSpec.describe "incidents/show", :type => :view do
  before(:each) do
    @incident = assign(:incident, Incident.create!(
      :description => "Description",
      :details => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
  end
end
