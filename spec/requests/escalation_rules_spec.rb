require 'rails_helper'

RSpec.describe "EscalationRules", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "GET /escalation_rules" do
    it "returns escalation rules" do
      escalation_rule = create(:escalation_rule)
      get escalation_rules_path, default_params
      expect(response.body).to be_json_as([{
        'id' => escalation_rule.id,
        'name' => escalation_rule.name,
        'escalations' => escalation_rule.escalations.map do |escalation|
          {
            'id' => escalation.id,
            'escalate_to_id' => escalation.escalate_to.id,
            'escalate_to_type' => escalation.escalate_to.class.name,
            'escalate_after' => escalation.escalate_after,
            'escalation_rule_id' => escalation_rule.id,
            'updated_at' => escalation.updated_at.as_json,
            'created_at' => escalation.created_at.as_json,
          }
        end,
        'url' => escalation_rule_url(escalation_rule, format: :json),
      }])
      expect(response.status).to be(200)
    end
  end

  describe "GET /escalation_rules/1" do
    it "returns an escalation rule" do
      escalation_rule = create(:escalation_rule)
      get escalation_rule_path(escalation_rule), default_params
      expect(response.body).to be_json_as({
        'id' => escalation_rule.id,
        'name' => escalation_rule.name,
        'escalations' => escalation_rule.escalations.map do |escalation|
          {
            'id' => escalation.id,
            'escalate_to_id' => escalation.escalate_to.id,
            'escalate_to_type' => escalation.escalate_to.class.name,
            'escalate_after' => escalation.escalate_after,
            'escalation_rule_id' => escalation_rule.id,
            'updated_at' => escalation.updated_at.as_json,
            'created_at' => escalation.created_at.as_json,
          }
        end,
        'updated_at' => escalation_rule.updated_at.as_json,
        'created_at' => escalation_rule.created_at.as_json,
      })
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
      escalation_rule = EscalationRule.last
      expect(escalation_rule.name).to eq(attributes[:name])
      expect(escalation_rule.escalations[0].escalate_to).to eq(user)
      expect(escalation_rule.escalations[0].escalate_after).to eq(60)
      expect(response.status).to be(201)
    end
  end
end
