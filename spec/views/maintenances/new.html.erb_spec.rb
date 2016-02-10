require 'rails_helper'

RSpec.describe "maintenances/new", :type => :view do
  before(:each) do
    assign(:maintenance, Maintenance.new(
      :topic => nil
    ))
  end

  it "renders new maintenance form" do
    render

    assert_select "form[action=?][method=?]", maintenances_path, "post" do

      assert_select "input#maintenance_topic_id[name=?]", "maintenance[topic_id]"
    end
  end
end
