require 'rails_helper'

RSpec.describe "escalations/index", :type => :view do
  before(:each) do
    assign(:escalations, [
      Escalation.create!(
        :escalate_to => nil,
        :escalate_after_sec => 1
      ),
      Escalation.create!(
        :escalate_to => nil,
        :escalate_after_sec => 1
      )
    ])
  end

  it "renders a list of escalations" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
