require "rails_helper"

RSpec.describe "Topics", type: :request do
  describe "POST /topics/1/mailgun" do
    let(:subject) { 'New Alert' }
    let(:body) { "Your server is on fire" }
    it "creates a new incident" do
      topic = create(:topic)
      post mailgun_topic_path(topic, format: :json), {
        'subject' => subject,
        'body-plain' => body,
      }
      expect(response).to have_http_status(200)

      incident = Incident.last
      expect(incident.subject).to eq(subject)
      expect(incident.description).to eq(body)
    end
  end
end
