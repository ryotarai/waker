require 'rails_helper'

RSpec.describe "escalation_series/edit", :type => :view do
  before(:each) do
    @escalation_series = assign(:escalation_series, EscalationSeries.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit escalation_series form" do
    render

    assert_select "form[action=?][method=?]", escalation_series_path(@escalation_series), "post" do

      assert_select "input#escalation_series_name[name=?]", "escalation_series[name]"
    end
  end
end
