require 'rails_helper'
describe "User", js_errors: false do
  let(:user) { Fabricate :user }
  let(:random) { Faker::Config.random }
  let(:password) { Faker::Config.random }
  let(:guest) { Fabricate :user, password: password, role: :guest }

  it "anlegen" do
    sign_in user
    visit "/users/new"
    expect(page.has_text?("Benutzer anlegen")).to be_truthy
    fill_in "user_name", with: "TestUser"
    fill_in "user_username", with: "test@rest.te"
    fill_in "user_password", with: random
    find('input[value="Speichern"]').click
    visit "/users"
    expect(page.has_text?("TestUser")).to be_truthy
  end

  it "bearbeiten" do
    pending "keine ahnung was falsch"
    sign_in user
    Fabricate :user
    visit "/users/1/edit"
    fill_in "user_name", with: "TestNameNew"
    fill_in "user_password", with: "123456"
    find('input[value="Speichern"]').click
    visit "/users"
    expect(page.has_text?("TestNameNew")).to be_truthy
  end

  it "löschen" do
    sign_in user
    Fabricate :user
    visit "/users"
    expect(page.has_text?(user.name)).to be_truthy
    accept_alert('Sind Sie sicher?') do
      page.all('.btn.btn-danger')[1].click
    end
    visit "/users"
    expect(page.has_text?(user.name)).to be_falsey
  end

  it "keine leeren Felder beim Anlegen" do
    sign_in user
    visit "/users/new"
    expect(page.has_text?("Benutzer anlegen")).to be_truthy
    fill_in "user_name", with: random
    find('input[value="Speichern"]').click
    expect(page.has_text?("Bitte überprüfen Sie die folgenden Felder:")).to be_truthy
  end
end
