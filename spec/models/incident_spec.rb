require 'rails_helper'
require 'tmpdir'

RSpec.describe Incident, :type => :model do
  describe "after_create enqueue" do
    it "create escalation workers" do
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          user = User.create!(name: 'user')
          user.notifiers.create!(kind: :file, settings: {path: './incident'})
          escalation_series = EscalationSeries.create!
          escalation_series.escalations.create!(escalate_to: user, escalate_after_sec: 60)
          topic = Topic.create!(name: 'topic', kind: :api, escalation_series: escalation_series)

          incident = nil
          expect do
            incident = Incident.create!(topic: topic, subject: 'subject', description: 'desc', occured_at: Time.now)
          end.to change(EscalationWorker.jobs, :size).by(1)

          expect do
            EscalationWorker.drain
          end.to change(NotificationWorker.jobs, :size).by(1)

          NotificationWorker.drain

          written_incident = JSON.parse(File.read(File.join(dir, 'incident')))
          expect(written_incident['subject']).to eq(incident.subject)
          expect(written_incident['description']).to eq(incident.description)
        end
      end
    end
  end
end
