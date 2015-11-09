Rails.application.configure do
  config.action_view.field_error_proc = lambda do |html_tag, instance|
    %Q{<div class="has-error">#{html_tag}</div>}.html_safe
  end
end
