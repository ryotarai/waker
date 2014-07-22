require 'rails_helper'

RSpec.describe "EscalationRules", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "GET /escalation_rules" do
    it "returns escalation rules" do
      escalation_rule = create(:escalation_rule)
      get escalation_rules_path, default_params
      response_attrs = json_response[0]

      expect(response_attrs['id']).to eq(escalation_rule.id)
      expect(response_attrs['name']).to eq(escalation_rule.name)
      escalation_rule.escalations.each_with_index do |escalation, i|
        expect(response_attrs['escalations'][i]['id']).to eq(escalation.id)
        expect(response_attrs['escalations'][i]['escalate_to_id']).to eq(escalation.escalate_to.id)
        expect(response_attrs['escalations'][i]['escalate_to_type']).to eq(escalation.escalate_to.class.name)
        expect(response_attrs['escalations'][i]['escalate_after']).to eq(escalation.escalate_after)
      end
      expect(response.status).to be(200)
    end
  end

  describe "GET /escalation_rules/1" do
    it "returns an escalation rule" do
      escalation_rule = create(:escalation_rule)
      get escalation_rule_path(escalation_rule), default_params
      response_attrs = json_response

      expect(response_attrs['id']).to eq(escalation_rule.id)
      expect(response_attrs['name']).to eq(escalation_rule.name)
      escalation_rule.escalations.each_with_index do |escalation, i|
        expect(response_attrs['escalations'][i]['id']).to eq(escalation.id)
        expect(response_attrs['escalations'][i]['escalate_to_id']).to eq(escalation.escalate_to.id)
        expect(response_attrs['escalations'][i]['escalate_to_type']).to eq(escalation.escalate_to.class.name)
        expect(response_attrs['escalations'][i]['escalate_after']).to eq(escalation.escalate_after)
      end
      expect(response.status).to be(200)
    end
  end

  describe "POST /escalation_rules" do
    it "creates an escalation rule" do
      user = create(:user)
      attributes = attributes_for(:escalation_rule).merge(
        escalations: [{escalate_to_id: user.id, escalate_to_type: 'User', escalate_after: 60}]
      )

      post escalation_rules_path, default_params.merge(escalation_rule: attributes)
      expect(EscalationRule.last.name).to eq(attributes[:name])
      expect(EscalationRule.last.escalations[0].escalate_to).to eq(user)
      expect(EscalationRule.last.escalations[0].escalate_after).to eq(60)
      expect(response.status).to be(201)
    end
  end
end
