require 'rails_helper'

RSpec.describe "escalations/new", :type => :view do
  before(:each) do
    assign(:escalation, Escalation.new(
      :escalate_to => nil,
      :escalate_after_sec => 1
    ))
  end

  it "renders new escalation form" do
    render

    assert_select "form[action=?][method=?]", escalations_path, "post" do

      assert_select "input#escalation_escalate_to_id[name=?]", "escalation[escalate_to_id]"

      assert_select "input#escalation_escalate_after_sec[name=?]", "escalation[escalate_after_sec]"
    end
  end
end
