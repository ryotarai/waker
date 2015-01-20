require 'rails_helper'

RSpec.describe "escalation_series/show", :type => :view do
  before(:each) do
    @escalation_series = assign(:escalation_series, EscalationSeries.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
