class AddProviderToNotifier < ActiveRecord::Migration
  def change
    add_reference :notifiers, :provider, index: true
    add_foreign_key :notifiers, :notifier_providers, column: 'provider_id'
  end
end
