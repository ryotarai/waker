class SlackController < ApplicationController
  skip_before_action :login_required, only: [:interactive]

  def interactive
    verify!

    message = payload['original_message']
    message['attachments'][0].delete('actions')

    user = payload['user']['name']

    text = ''
    payload['actions'].each do |a|
      case a['value']
      when 'acknowledge'
        incident.acknowledge!
        text = ":white_check_mark: @#{user} acknowledged"
      when 'resolve'
        incident.resolve!
        text = ":white_check_mark: @#{user} resolved"
      end
    end

    message['attachments'][0]['fields'] = [{
      'title' => text,
      'value' => '',
      'short' => false,
    }]

    render json: message
  end

  private def payload
    JSON.parse(params[:payload])
  end

  private def verify!
    verified = false
    Notifier.preload(:provider).find_each do |n|
      settings = n.provider.settings.merge(n.settings)
      token = settings['verification_token']
      if n.provider.slack? && settings['enable_buttons'] && payload['token'] == token
        verified = true
        break
      end
    end

    unless verified
      raise 'token verification failed'
    end
  end

  private def incident_id
    payload['callback_id'].match(/\Aincident\.(\d+)\z/)[1].to_i
  end

  private def incident
    Incident.find(incident_id)
  end
end
