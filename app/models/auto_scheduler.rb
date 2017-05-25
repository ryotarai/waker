class AutoScheduler
  def initialize(series)
    @series = series
  end

  def update!
    raise NotImplementedError
  end

  def user_as
    User.find(@series.settings.fetch('user_as_id'))
  end

  def calendar_name
    @series.settings.fetch('calendar')
  end

  def event_delimiter
    @series.settings.fetch('event_delimiter')
  end
end
