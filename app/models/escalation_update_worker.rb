class EscalationUpdateWorker
  include Sidekiq::Worker

  def perform
    EscalationSeries.all.each do |series|
      handle_series(series)
    end
  rescue => err
    Rails.logger.error "#{err.class}: #{err}\n#{err.backtrace.join("\n")}"
  end

  private

  def handle_series(series)
    series.update_escalations!
  end
end
