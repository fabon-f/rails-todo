def capybara_login(email, password)
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Log in"
end
