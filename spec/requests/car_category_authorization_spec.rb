# require 'rails_helper'

describe 'Car category authorization' do
  it 'must be logged in to create' do
    post car_categories_path, params: {}

    expect(response).to redirect_to new_user_session_path
  end
end