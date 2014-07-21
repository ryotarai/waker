require 'rails_helper'

RSpec.describe "escalations/edit", :type => :view do
  before(:each) do
    @escalation = assign(:escalation, Escalation.create!(
      :rule => ""
    ))
  end

  it "renders the edit escalation form" do
    render

    assert_select "form[action=?][method=?]", escalation_path(@escalation), "post" do

      assert_select "input#escalation_rule[name=?]", "escalation[rule]"
    end
  end
end
