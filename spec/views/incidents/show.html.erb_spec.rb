require 'rails_helper'

RSpec.describe "incidents/show", :type => :view do
  before(:each) do
    @incident = assign(:incident, Incident.create!(
      :subject => "Subject",
      :description => "MyText",
      :topic => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Subject/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
