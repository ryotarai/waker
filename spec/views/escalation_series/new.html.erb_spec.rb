require 'rails_helper'

RSpec.describe "escalation_series/new", :type => :view do
  before(:each) do
    assign(:escalation_series, EscalationSeries.new(
      :name => "MyString"
    ))
  end

  it "renders new escalation_series form" do
    render

    assert_select "form[action=?][method=?]", escalation_series_index_path, "post" do

      assert_select "input#escalation_series_name[name=?]", "escalation_series[name]"
    end
  end
end
