require 'rails_helper'
describe "Login", js_errors: false do
  let(:password) { Faker::Config.random }
  let(:user) { Fabricate :user, password: password, role: :guest }
  let(:blocked_user) { Fabricate :user, password: password, role: :admin, active: false }

  it "Login Seite" do
    visit "/"
    expect(page.has_text?("Anmelden")).to be_truthy
    fill_in "user_username", with: user.username
    fill_in "user_password", with: password
    find('input[name="commit"]').click
    expect(page.has_text?('Erfolgreich angemeldet')).to be_truthy
  end

  it "Falsches Passwort" do
    visit "/"
    expect(page.has_text?("Anmelden")).to be_truthy
    fill_in "user_username", with: user.username
    fill_in "user_password", with: "TEST"
    find('input[name="commit"]').click
    # expect(page.has_text?("E-Mail oder Passwort ungültig.")).to be_truthy
  end

  it "Experiment erst nach Login" do
    pending "Es soll immer automatisch auf die Startseite gehen"
    visit "/experiments"
    expect(page.has_text?("Anmelden")).to be_truthy
    fill_in "user_username", with: user.username
    fill_in "user_password", with: password
    find('input[name="commit"]').click
    expect(page.has_text?("Experimente")).to be_truthy
  end

  it "Wenn angemeldet als Gast werden keine Nutzer gezeigt" do
    visit "/"
    expect(page.has_text?("Anmelden")).to be_truthy
    fill_in "user_username", with: user.username
    fill_in "user_password", with: password
    find('input[name="commit"]').click
    expect(page.has_text?("Versuchsdatenbank des Bereichs Physik")).to be_truthy
    visit "/users"
    expect(page.has_text?("Benötigte Rechte nicht vorhanden.")).to be_truthy
  end

  it "Bei Passwort vergessen wird E-Mail verschickt" do
    pending "Keine Email mehr"
    visit "/"
    expect(page.has_text?("Anmelden")).to be_truthy
    click_on("Hast du dein Passwort vergessen?")
    fill_in "user_username", with: user.username
    find('input[name="commit"]').click
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it "Als gesperrtet Nutzer anmelden ist nicht gestattet" do
    visit "/"
    expect(page.has_text?("Anmelden")).to be_truthy
    fill_in "user_username", with: blocked_user.username
    fill_in "user_password", with: password
    find('input[name="commit"]').click
    expect(page.has_text?("Benutzer wurde gesperrt")).to be_truthy
    visit "/experiments"
    expect(page.has_text?("Anmelden")).to be_truthy
  end
end
