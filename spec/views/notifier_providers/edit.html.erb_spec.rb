require 'rails_helper'

RSpec.describe "notifier_providers/edit", :type => :view do
  before(:each) do
    @notifier_provider = assign(:notifier_provider, NotifierProvider.create!(
      :name => "MyString",
      :kind => 1,
      :settings => "MyText"
    ))
  end

  it "renders the edit notifier_provider form" do
    render

    assert_select "form[action=?][method=?]", notifier_provider_path(@notifier_provider), "post" do

      assert_select "input#notifier_provider_name[name=?]", "notifier_provider[name]"

      assert_select "input#notifier_provider_kind[name=?]", "notifier_provider[kind]"

      assert_select "textarea#notifier_provider_settings[name=?]", "notifier_provider[settings]"
    end
  end
end
