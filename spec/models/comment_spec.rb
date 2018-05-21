require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:incident) { create(:incident) }
  let(:user) { create(:user) }

  it 'should be valid' do
    comment = Comment.new(
      incident: incident,
      user: user,
      comment: 'Help Me',
    )
    expect(comment).to be_valid
  end

  it 'should be invalid without incident' do
    comment = Comment.new(
      incident: nil,
      user: user,
      comment: 'Help Me',
    )
    expect(comment).not_to be_valid
  end

  it 'should be invalid without user' do
    comment = Comment.new(
      incident: incident,
      user: nil,
      comment: 'Help Me',
    )
    expect(comment).not_to be_valid
  end

  it 'should be invalid without comment' do
    comment = Comment.new(
      incident: incident,
      user: user,
      comment: '',
    )
    expect(comment).not_to be_valid
  end
end
