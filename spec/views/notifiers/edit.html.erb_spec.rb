require 'rails_helper'

RSpec.describe "notifiers/edit", :type => :view do
  before(:each) do
    @notifier = assign(:notifier, Notifier.create!(
      :type => "",
      :settings => "MyText",
      :notify_after_sec => 1
    ))
  end

  it "renders the edit notifier form" do
    render

    assert_select "form[action=?][method=?]", notifier_path(@notifier), "post" do

      assert_select "input#notifier_type[name=?]", "notifier[type]"

      assert_select "textarea#notifier_settings[name=?]", "notifier[settings]"

      assert_select "input#notifier_notify_after_sec[name=?]", "notifier[notify_after_sec]"
    end
  end
end
