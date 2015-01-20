require 'rails_helper'

RSpec.describe "topics/show", :type => :view do
  before(:each) do
    @topic = assign(:topic, Topic.create!(
      :name => "Name",
      :type => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
