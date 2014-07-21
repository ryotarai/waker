require 'rails_helper'

RSpec.describe "escalations/new", :type => :view do
  before(:each) do
    assign(:escalation, Escalation.new(
      :rule => ""
    ))
  end

  it "renders new escalation form" do
    render

    assert_select "form[action=?][method=?]", escalations_path, "post" do

      assert_select "input#escalation_rule[name=?]", "escalation[rule]"
    end
  end
end
