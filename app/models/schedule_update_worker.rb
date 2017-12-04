class ScheduleUpdateWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info "AutoScheduler start."
    EscalationSeries.all.each do |series|
      updater_class = case series.settings['schedule_by']
                      when 'google_calendar'
                        CalendarDescriptionAutoScheduler
                      else
                        nil
                      end
      if updater_class
        updater = updater_class.new(series)
        handle_updater(updater)
      end
    end

  rescue => err
    Rails.logger.error "#{err.class}: #{err}\n#{err.backtrace.join("\n")}"
  end

  private

  def handle_updater(updater)
    updater.update!
  end
end
