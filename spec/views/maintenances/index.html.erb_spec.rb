require 'rails_helper'

RSpec.describe "maintenances/index", :type => :view do
  before(:each) do
    assign(:maintenances, [
      Maintenance.create!(
        :topic => nil
      ),
      Maintenance.create!(
        :topic => nil
      )
    ])
  end

  it "renders a list of maintenances" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
