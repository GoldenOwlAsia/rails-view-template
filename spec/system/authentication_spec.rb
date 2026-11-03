require 'rails_helper'

RSpec.describe 'Authentication' do
  let(:password) { 'Password123@' }

  describe 'visiting a protected page while signed out' do
    it 'redirects to the sign in page', :aggregate_failures do
      visit root_path

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_button('Log in')
    end
  end

  describe 'signing in' do
    it 'sends an employee to the home page', :aggregate_failures do
      user = create(:user, password:)

      sign_in_with(user.email, password)

      expect(page).to have_current_path(root_path)
      expect(page).to have_text('Illuminating Excellence')
    end

    it 'sends an admin to the admin dashboard' do
      user = create(:user, :admin, password:)

      sign_in_with(user.email, password)

      expect(page).to have_current_path(admin_root_path)
    end

    it 'keeps the user on the sign in page when the password is wrong', :aggregate_failures do
      user = create(:user, password:)

      sign_in_with(user.email, 'wrong-password')

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_button('Log in')
    end
  end

  describe 'signing out' do
    it 'returns the user to the sign in page' do
      user = create(:user, password:)
      sign_in user

      visit root_path
      click_button 'Log out'

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  describe 'authorization' do
    it 'keeps an employee out of the admin area' do
      user = create(:user, password:)
      sign_in user

      visit admin_root_path

      expect(page).to have_current_path(root_path)
    end
  end

  def sign_in_with(email, password)
    visit new_user_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end
end
