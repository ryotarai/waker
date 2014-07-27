require 'rails_helper'

RSpec.describe "Shifts", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "GET /api/v1/shifts" do
    it "returns shifts" do
      shift = create(:shift)
      get api_shifts_path, default_params
      expect(response.body).to be_json_as([{
        'id' => shift.id,
        'name' => shift.name,
        'ical' => shift.ical,
        'url' => api_shift_url(shift, format: :json),
      }])
      expect(response.status).to be(200)
    end
  end
end
