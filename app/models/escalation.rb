class Escalation
  include Mongoid::Document
  field :name, type: String
  field :rules, type: Array

  validates :name, presence: true
  validates :rules, presence: true

  def decoded_rules
    self.rules.map do |rule|
      rule['at'] ||= 0
      rule['target'] = case
                       when rule['user']
                         User.find(rule['user'])
                       else
                         raise "No escalation target found"
                       end
      rule
    end
  end
end
