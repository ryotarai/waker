require 'rails_helper'

RSpec.describe "escalations/show", :type => :view do
  before(:each) do
    @escalation = assign(:escalation, Escalation.create!(
      :escalate_to => nil,
      :escalate_after_sec => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
  end
end
