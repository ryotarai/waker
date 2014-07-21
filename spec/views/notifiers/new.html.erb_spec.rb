require 'rails_helper'

RSpec.describe "notifiers/new", :type => :view do
  before(:each) do
    assign(:notifier, Notifier.new(
      :user => "MyString",
      :notify_after => 1,
      :type => "",
      :details => ""
    ))
  end

  it "renders new notifier form" do
    render

    assert_select "form[action=?][method=?]", notifiers_path, "post" do

      assert_select "input#notifier_user[name=?]", "notifier[user]"

      assert_select "input#notifier_notify_after[name=?]", "notifier[notify_after]"

      assert_select "input#notifier_type[name=?]", "notifier[type]"

      assert_select "input#notifier_details[name=?]", "notifier[details]"
    end
  end
end
