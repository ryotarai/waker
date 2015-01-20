require 'rails_helper'

RSpec.describe "escalations/edit", :type => :view do
  before(:each) do
    @escalation = assign(:escalation, Escalation.create!(
      :escalate_to => nil,
      :escalate_after_sec => 1
    ))
  end

  it "renders the edit escalation form" do
    render

    assert_select "form[action=?][method=?]", escalation_path(@escalation), "post" do

      assert_select "input#escalation_escalate_to_id[name=?]", "escalation[escalate_to_id]"

      assert_select "input#escalation_escalate_after_sec[name=?]", "escalation[escalate_after_sec]"
    end
  end
end
