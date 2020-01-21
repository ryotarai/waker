require 'rails_helper'
require 'ostruct'
require 'google/api_client'
require 'json'

RSpec.describe EscalationSeries, type: :model do
  describe "after_create enqueue" do
    before do
      # I understand that this is not the recommended method, but it is enough.
      allow_any_instance_of(Google::APIClient).to receive(:execute).and_return(
        OpenStruct.new(
          {
            data: OpenStruct.new({
              items: [{
                'id' => 1,
                'summary' => 'test_calendar'
              }]
            })
          }
        ),
        OpenStruct.new(
          {
              data: OpenStruct.new({
                items: [{
                  'summary' => 'c,b,a',
                  'start' => { 'dateTime' => Time.now },
                  'end' => { 'dateTime' => Time.now + 300 },
                }]
              })
          }
        ),
      )
    end

    it "#update_escalations" do
      users = %w(a b c).map { |n| create(:user, name: n, credentials: { expires_at: Time.now.to_i + 300, token: "dummy", expires: nil, }) }
      series = create(:escalation_series, settings: {
        update_by: 'google_calendar',
        user_as_id: users.first.id,
        calendar: 'test_calendar',
        event_delimiter: ',',
      })
      escalations = users.map { |u| create(:escalation, escalation_series: series, escalate_to: u ) }

      expect(series.update_escalations!).to be_truthy

      users.reverse.each_with_index do |u,i|
        expect(Escalation.find(escalations[i].id).escalate_to.id).to eq(u.id)
      end
    end
  end
end
