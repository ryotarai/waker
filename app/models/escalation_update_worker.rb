class EscalationUpdateWorker
  include Sidekiq::Worker

  def self.enqueue
    self.perform_in(60)
  end

  def perform
    EscalationSeries.all.each do |series|
      handle_series(series)
    end

    self.class.enqueue
  end

  private

  def handle_series(series)
    series.update_escalations
  end
end

job = Sidekiq::Queue.new.find do |j|
  j.klass == 'EscalationUpdateWorker'
end

unless job
  EscalateUpdateWorker.enqueue
end
