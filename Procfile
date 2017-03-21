web: bin/rails s
worker: bundle exec sidekiq
auto_scheduler: while true; do bundle exec rails runner 'ScheduleUpdateWorker.perform_async()'; sleep 7200; done
update_escalations: while true; do bundle exec rails runner 'EscalationUpdateWorker.perform_async()'; sleep 60; done
