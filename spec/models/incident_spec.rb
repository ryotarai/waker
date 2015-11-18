require 'rails_helper'

RSpec.describe Incident, :type => :model do
  describe "after_create enqueue" do
    it "creates escalation jobs" do
      series = create(:escalation_series)
      escalation = create(:escalation, escalation_series: series)
      notifier = create(:notifier, user: escalation.escalate_to)
      topic = create(:topic, escalation_series: series)

      incident = nil
      expect {
        incident = create(:incident, topic: topic)
      }.to change(EscalationWorker.jobs, :size).by(1).and change(NotificationWorker.jobs, :size).by(1)

      expect {
        EscalationWorker.drain
      }.to change(incident.events, :count).by(1)

      event = incident.events.last
      expect(event.kind).to eq('escalated')
      expect(event.escalation).to eq(escalation)

      expect(NotificationWorker.jobs.size).to eq(2)
    end
  end
end
