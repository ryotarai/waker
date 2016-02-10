require 'rails_helper'

RSpec.describe "maintenances/edit", :type => :view do
  before(:each) do
    @maintenance = assign(:maintenance, Maintenance.create!(
      :topic => nil
    ))
  end

  it "renders the edit maintenance form" do
    render

    assert_select "form[action=?][method=?]", maintenance_path(@maintenance), "post" do

      assert_select "input#maintenance_topic_id[name=?]", "maintenance[topic_id]"
    end
  end
end
