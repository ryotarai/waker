require 'rails_helper'

RSpec.describe "providers/show", :type => :view do
  before(:each) do
    @provider = assign(:provider, Provider.create!(
      :type => "Type",
      :details => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Type/)
    expect(rendered).to match(//)
  end
end
