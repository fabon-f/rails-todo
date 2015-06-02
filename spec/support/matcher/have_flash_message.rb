RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert-box.radius.error', text: message)
  end
end

RSpec::Matchers.define :have_notice_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert-box.radius.notice', text: message)
  end
end
