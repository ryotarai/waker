require 'rails_helper'

RSpec.describe Incident, :type => :model do
  describe "create" do
    it "adds jobs to escalation queue" do
      incident = create(:incident)
      EscalationQueue.all.each_with_index do |job, i|
        escalation = incident.provider.escalation_rule.escalations[i]
        expect(job.incident).to eq(incident)
        expect(job.escalation).to eq(escalation)
        expect(job.escalate_at.to_i).to eq(Time.now.to_i + escalation.escalate_after)
      end
    end
  end
end
