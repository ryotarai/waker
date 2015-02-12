require 'rails_helper'

RSpec.describe "escalation_series/index", :type => :view do
  before(:each) do
    assign(:escalation_series, [
      EscalationSeries.create!(
        :name => "Name"
      ),
      EscalationSeries.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of escalation_series" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
