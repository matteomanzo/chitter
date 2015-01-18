# require 'spec_helper'

# feature 'user signs up' do

#   def sign_up(email = "maker@example.com",
#             password = "ruby",
#             password_confirmation = "ruby")
#     visit '/users/new'
#     expect(page.status_code).to eq(200)
#     fill_in :email, :with => email
#     fill_in :password, :with => password
#     fill_in :password_confirmation, :with => password_confirmation
#     click_button "Sign up"
#   end

#   scenario "when being a new maker user visiting the site" do
#     expect{sign_up}.to change(User, :count).by(1)
#     expect(page).to have_content("Welcome, maker@example.com")
#     expect(User.first.email).to eq("maker@example.com")
#   end

#   scenario "with a password that doesn't match" do
#     expect{ sign_up('maker@makers.com', 'pass', 'wrong') }.to change(User, :count).by(0)
#     expect(current_path).to eq('/users')
#     expect(page).to have_content("Password does not match the confirmation")
#   end

#   scenario 'with an email that is already registered' do
#     expect { sign_up }.to change(User, :count).by 1
#     expect { sign_up }.to change(User, :count).by 0
#     expect(page).to have_content("Email is already taken")
#   end
# end