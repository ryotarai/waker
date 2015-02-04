class EscalationUpdateWorker
  include Sidekiq::Worker

  def perform
    EscalationSeries.all.each do |series|
      handle_series(series)
    end
  end

  private

  def handle_series(series)
    series.update_escalations!
  end
end

