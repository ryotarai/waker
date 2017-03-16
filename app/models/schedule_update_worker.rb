class ScheduleUpdateWorker
  include Sidekiq::Worker

  def perform
    EscalationSeries.all.each do |series|
      updater_class = case series.settings['schedule_by']
                      when 'calendar_description'
                        CalendarDescriptionAutoScheduler
                      else
                        nil
                      end
      if updater_class
        updater = updater_class.new(series)
        updater.update!
      end
    end

  rescue => err
    Rails.logger.error "#{err.class}: #{err}\n#{err.backtrace.join("\n")}"
  end

end
