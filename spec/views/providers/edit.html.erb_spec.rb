require 'rails_helper'

RSpec.describe "providers/edit", :type => :view do
  before(:each) do
    @provider = assign(:provider, Provider.create!(
      :type => "",
      :details => ""
    ))
  end

  it "renders the edit provider form" do
    render

    assert_select "form[action=?][method=?]", provider_path(@provider), "post" do

      assert_select "input#provider_type[name=?]", "provider[type]"

      assert_select "input#provider_details[name=?]", "provider[details]"
    end
  end
end
