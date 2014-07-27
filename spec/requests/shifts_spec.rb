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

  describe "GET /api/v1/shifts/1" do
    it "returns a shift" do
      shift = create(:shift)
      get api_shift_path(shift), default_params
      expect(response.body).to be_json_as({
        'id' => shift.id,
        'name' => shift.name,
        'ical' => shift.ical,
        'updated_at' => shift.updated_at.as_json,
        'created_at' => shift.created_at.as_json,
      })
      expect(response.status).to be(200)
    end
  end

  describe "POST /api/v1/shifts" do
    it "creates a shift" do
      shift = create(:shift)
      attributes = attributes_for(:shift)
      post api_shifts_path, default_params.merge(shift: attributes)
      shift = Shift.last
      expect(shift.name).to eq(attributes[:name])
      expect(shift.ical).to eq(attributes[:ical])
      expect(response.status).to be(201)
    end
  end
end
