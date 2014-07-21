require 'rails_helper'

RSpec.describe "escalations/show", :type => :view do
  before(:each) do
    @escalation = assign(:escalation, Escalation.create!(
      :rule => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
