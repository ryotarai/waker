require 'rails_helper'

RSpec.describe "notifiers/edit", :type => :view do
  before(:each) do
    @notifier = assign(:notifier, Notifier.create!(
      :user => "MyString",
      :notify_after => 1,
      :type => "",
      :details => ""
    ))
  end

  it "renders the edit notifier form" do
    render

    assert_select "form[action=?][method=?]", notifier_path(@notifier), "post" do

      assert_select "input#notifier_user[name=?]", "notifier[user]"

      assert_select "input#notifier_notify_after[name=?]", "notifier[notify_after]"

      assert_select "input#notifier_type[name=?]", "notifier[type]"

      assert_select "input#notifier_details[name=?]", "notifier[details]"
    end
  end
end
