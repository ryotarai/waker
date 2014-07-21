require 'rails_helper'

RSpec.describe "escalations/index", :type => :view do
  before(:each) do
    assign(:escalations, [
      Escalation.create!(
        :rule => ""
      ),
      Escalation.create!(
        :rule => ""
      )
    ])
  end

  it "renders a list of escalations" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
