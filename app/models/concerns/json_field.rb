module JsonField
  extend ActiveSupport::Concern

  module ClassMethods
    def json_field(name)
      define_method(name) do
        return {} unless self.public_send("#{name}_json")
        JSON.parse(self.public_send("#{name}_json"))
      end
      define_method("#{name}=") do |obj|
        self.public_send("#{name}_json=", obj.to_json)
      end
    end
  end
end
