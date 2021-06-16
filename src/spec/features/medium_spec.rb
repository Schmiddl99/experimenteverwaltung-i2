require 'rails_helper'
describe "Medium", js_errors: false do
  let(:user) { Fabricate :user }
  let(:random) { Faker::Config.random }
  let(:sub_category) { Fabricate :sub_category }
  let(:image) { Rails.root.join('spec', 'fixtures', 'file2.jpg') }
  let(:trashmedium) { Fabricate :medium, experiment: nil }
  # @vincent.thelang

  it "anlegen", js: true do
    sign_in user
    Fabricate :experiment
    visit "/experiments/new"
    find("#experiment_name").set("TestName_1")
    find("#experiment_label").set("TestLabel.1")
    find("#experiment_description").set("TestBeschreibung")
    attach_file("experiment_media_attributes_0_file", image, visible: false)
    find('#experiment-save').click
    expect(page.html.include?("/uploads/media/medium/1.png")).to be_truthy
    expect(page.has_text?("Experiment wurde erstellt")).to be_truthy
  end

  it "ändern", js: true do
    sign_in user
    Fabricate :medium
    visit "/experiments/1/edit"
    expect(page.html.include?("/uploads/media/thumb/1.png")).to be_truthy
    attach_file("experiment_media_attributes_0_file", image, visible: false)
    find('input[value="Speichern"]').click
    expect(page.has_text?("file2")).to be_truthy
    expect(page.has_text?("file1")).to be_falsey
    expect(page.html.include?("/uploads/media/medium/1.png")).to be_truthy
  end

  it "weiteres hinzufügen", js: true do
    sign_in user
    Fabricate :medium
    visit "/experiments/1/edit"
    attach_file("experiment_media_attributes_1_file", image, visible: false)
    expect(page.html.include?("/uploads/media/thumb/1.png")).to be_truthy
    find('input[value="Speichern"]').click
    expect(page.has_text?("file2")).to be_truthy
    expect(page.has_text?("file1")).to be_truthy
    expect(page.html.include?("/uploads/media/medium/1.png")).to be_truthy
    expect(page.html.include?("/uploads/media/medium/2.png")).to be_truthy
  end

  it "löschen" do
    pending "lösch button test funkt nicht"
    sign_in user
    Fabricate :medium
    visit "/experiments/1/edit"
    expect(page.html.include?("/uploads/media/thumb/1.png")).to be_truthy
    accept_alert('Möchten Sie dies wirklich löschen?') do
      page.all('.btn.btn-link.times-nested-forms.remove_fields.existing')[0].click
    end
    page.all('.btn.btn-link.times-nested-forms.remove_fields.dynamic')[0].click
    expect(page.html.include?("/uploads/media/thumb/1.png")).to be_falsey
    find('input[value="Speichern"]').click
    expect(page.html.include?("/uploads/media/medium/1.png")).to be_falsey
    expect(page.has_text?("file1")).to be_falsey
    visit "/media"
    expect(page.html.include?("/uploads/media/original/1.png")).to be_truthy
  end

  it "endgültig löschen" do
    pending "Taucht nicht im Papierkorb auf"
    sign_in user
    trashmedium
    visit "/media"
    expect(page.html.include?("/uploads/media/original/1.png")).to be_truthy
    find('a[class="btn btn-danger"]').click
    expect(page.html.include?("/uploads/media/original/1.png")).to be_falsey
  end

  it "wiederherstellen" do
    pending "Taucht nicht im Papierkorb auf"
    # @vincent.thelang
    sign_in user
    trashmedium
    Fabricate :experiment
    visit "/media"
    expect(page.html.include?("/uploads/media/original/1.png")).to be_truthy
    find('a[class="btn btn-secondary btn-hover--jade"]').click
    select "TestExperiment", from: "medium_experiment_id"
    find('input[value="Speichern"]').click
    expect(page.html.include?("/uploads/media/original/1.png")).to be_falsey
  end

  it "anlegen (alternativ)", js: true do
    pending "kann kein attachment anlegen"
    # ...
    sign_in user
    Fabricate :experiment
    sign_in user
    visit "/media/new"
    expect(page.has_text?("Bilder und Video anlegen")).to be_truthy
    select "TestExperiment", from: "medium_experiment_id"
    attach_file("medium_file", image, visible: false)
    find('input[value="Speichern"]').click
    expect(page.has_text?("Bilder und Video wurde erstellt")).to be_truthy
    visit "/experiments/1"
    expect(page.html.include?("/uploads/media/medium/1.jpg")).to be_truthy
    visit "/media/1"
    expect(page.html.include?("/uploads/media/original/1.jpg")).to be_truthy
  end
end
