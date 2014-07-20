require 'rails_helper'

RSpec.describe "providers/new", :type => :view do
  before(:each) do
    assign(:provider, Provider.new(
      :type => "",
      :details => ""
    ))
  end

  it "renders new provider form" do
    render

    assert_select "form[action=?][method=?]", providers_path, "post" do

      assert_select "input#provider_type[name=?]", "provider[type]"

      assert_select "input#provider_details[name=?]", "provider[details]"
    end
  end
end
