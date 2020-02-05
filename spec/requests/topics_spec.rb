require "rails_helper"

RSpec.describe "Topics", type: :request do
  describe "POST /topics/1/mailgun" do
    let(:subject) { 'New Alert' }
    let(:body) { "Your server is on fire" }
    it "creates a new incident" do
      topic = create(:topic)
      post mailgun_topic_path(topic, format: :json), params: {
        'subject' => subject,
        'body-plain' => body,
      }
      expect(response).to have_http_status(200)

      incident = Incident.last
      expect(incident.subject).to eq(subject)
      expect(incident.description).to eq(body)
    end
  end

  describe "POST /topics/1/slack" do
    it "creates a new incident" do
      topic = create(:topic)
      post slack_topic_path(topic, format: :json), params: {
        'channel_name' => 'test_channel',
        'user_name' => 'test_user',
        'text' => 'help me',
      }
      expect(response).to have_http_status(200)

      incident = Incident.last
      expect(incident.subject).to eq("channel:test_channel user:test_user")
      expect(incident.description).to eq("help me")
    end
  end
end
