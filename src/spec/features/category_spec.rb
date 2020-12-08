require 'rails_helper'
describe "Category", js_errors: false do
  let(:user) { Fabricate :user }
  let(:random) { Faker::Config.random }
  let(:password) { Faker::Config.random }
  let(:guest) { Fabricate :user, password: password, role: :guest }
  let(:category) { Fabricate :category, name: 'Test2' }

  it "anlegen" do
    sign_in user
    visit "/categories/new"
    expect(page.has_text?("Kategorie anlegen")).to be_truthy
    fill_in "category_name", with: random
    fill_in "category_label", with: random
    click_button("Speichern")
    expect(page.has_text?(random)).to be_truthy
  end

  it "bearbeiten" do
    sign_in user
    Fabricate :category
    visit "/categories/1/edit"
    fill_in "category_name", with: "TestNameNew"
    find('input[value="Speichern"]').click
    expect(page.has_text?("TestNameNew")).to be_truthy
  end

  it "löschen" do
    pending "Löschen der Kategorie nicht noch möglich"
    sign_in user
    Fabricate :category
    visit "/categories"
    expect(page.has_text?("TestCategory")).to be_truthy
    find('a[class="btn btn-danger"]').click
    expect(page.has_text?("TestCategory")).to be_falsey
  end

  it "keine leeren Felder beim Anlegen" do
    sign_in user
    visit "/categories/new"
    expect(page.has_text?("Kategorie anlegen")).to be_truthy
    fill_in "category_name", with: random
    find('input[value="Speichern"]').click
    expect(page.has_text?("Bitte überprüfen Sie die folgenden Felder:")).to be_truthy
  end

  it "Gast möchte seite aufrufen" do
    sign_in guest
    visit "/categories/new"
    expect(page.has_text?("Benötigte Rechte nicht vorhanden.")).to be_truthy
    visit "/categories"
    # soll nicht lösch und bearbeiten button finden
    # expect(page).should_not(find('a[data-method="delete"]'))
    # expect(find('a[data-method="delete"]').visible?).to be_falsey
  end

  it "vor und zurück" do
    sign_in user
    Fabricate :category
    category
    visit "/categories/2"
    expect(page.has_text?("Test2")).to be_truthy
    find('i.fa.fs.fa-arrow-right').click
    expect(page.has_text?("TestCategory")).to be_truthy
    find('i.fa.fs.fa-arrow-left').click
    expect(page.has_text?("Test2")).to be_truthy
  end
end
