require 'rails_helper'

RSpec.describe "notifier_providers/new", :type => :view do
  before(:each) do
    assign(:notifier_provider, NotifierProvider.new(
      :name => "MyString",
      :kind => 1,
      :settings => "MyText"
    ))
  end

  it "renders new notifier_provider form" do
    render

    assert_select "form[action=?][method=?]", notifier_providers_path, "post" do

      assert_select "input#notifier_provider_name[name=?]", "notifier_provider[name]"

      assert_select "input#notifier_provider_kind[name=?]", "notifier_provider[kind]"

      assert_select "textarea#notifier_provider_settings[name=?]", "notifier_provider[settings]"
    end
  end
end
