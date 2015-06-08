def capybara_login(email, password, visit_login_path: true)
  visit login_path if visit_login_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Log in"
end
