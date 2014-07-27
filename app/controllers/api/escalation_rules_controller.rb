module Api
  class EscalationRulesController < ApplicationController
    before_action :set_escalation_rule, only: [:show, :edit, :update, :destroy]

    def index
      @escalation_rules = EscalationRule.all
      respond_with(:api, @escalation_rules)
    end

    def show
      respond_with(:api, @escalation_rule)
    end

    def new
      @escalation_rule = EscalationRule.new
      respond_with(:api, @escalation_rule)
    end

    def edit
    end

    def create
      @escalation_rule = EscalationRule.new(escalation_rule_params)
      @escalation_rule.save
      respond_with(:api, @escalation_rule)
    end

    def update
      @escalation_rule.update(escalation_rule_params)
      respond_with(:api, @escalation_rule)
    end

    def destroy
      @escalation_rule.destroy
      respond_with(:api, @escalation_rule)
    end

    private
      def set_escalation_rule
        @escalation_rule = EscalationRule.find(params[:id])
      end

      def escalation_rule_params
        escalation_rule = params.require(:escalation_rule)
        escalation_rule.permit(:name).tap do |permitted|
          permitted[:escalations_hash_array] = escalation_rule[:escalations]
        end
      end
  end
end
