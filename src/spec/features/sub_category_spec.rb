require 'rails_helper'
describe "Subcategory", js_errors: false do
  let(:user) { Fabricate :user }
  let(:random) { Faker::Config.random }
  let(:subcategory) { Fabricate :sub_category, name: 'Test2', label: "bla" }

  it "anlegen" do
    sign_in user
    Fabricate :category
    visit "/sub_categories/new"
    expect(page.has_text?("Unterkategorie anlegen")).to be_truthy
    fill_in "sub_category_name", with: random
    fill_in "sub_category_label", with: random
    select "TestCategory", from: "sub_category_category_id"
    find('input[value="Speichern"]').click
    expect(page.has_text?(random)).to be_truthy
  end

  it "bearbeiten" do
    sign_in user
    Fabricate :sub_category
    visit "/sub_categories/1/edit"
    fill_in "sub_category_name", with: "TestNameNew"
    find('input[value="Speichern"]').click
    expect(page.has_text?("TestNameNew")).to be_truthy
  end

  it "löschen" do
    sign_in user
    Fabricate :sub_category
    visit "/sub_categories"
    expect(page.has_text?("TestSubCategory")).to be_truthy
    accept_alert('Sind Sie sicher?') do
      find('a[class="btn btn-danger"]').click
    end
    expect(page.has_text?("Unterkategorie wurde gelöscht"))
    visit "/sub_categories"
    expect(page.has_text?("TestSubCategory")).to be_falsey
  end

  it "vor und zurück" do
    sign_in user
    subcategory
    Fabricate :sub_category, category: subcategory.category
    visit "/sub_categories/1"
    expect(page.has_text?("Test2")).to be_truthy
    find('i.fa.fs.fa-arrow-right').click
    expect(page.has_text?("TestSubCategory")).to be_truthy
    find('i.fa.fs.fa-arrow-left').click
    expect(page.has_text?("Test2")).to be_truthy
  end
end
