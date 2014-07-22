class EscalationRule < ActiveRecord::Base
  has_many :escalations

  def escalations_hash_array=(array)
    self.escalations.destroy_all
    self.escalations = array.map do |hash|
      unless %w!User!.include?(hash[:escalate_to_type])
        raise 'Unacceptable escalate_to_type'
      end
      klass = Kernel.const_get(hash[:escalate_to_type])
      escalate_to = klass.find(hash[:escalate_to_id])
      escalate_after = hash[:escalate_after] || 0
      Escalation.new(
        escalate_to: escalate_to, escalate_after: escalate_after
      )
    end
  end
end
