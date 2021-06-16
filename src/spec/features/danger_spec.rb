require 'rails_helper'
describe "Danger" do
  let(:user) { Fabricate :user }
  let(:random) { Faker::Config.random }
  let(:image) { Rails.root.join('spec', 'fixtures', 'file2.jpg') }
  let(:newdanger) { Fabricate :danger, name: "TestGefahrNew", label: "NewLabel" }

  it "anlegen", js: true do
    sign_in user
    visit "/dangers"
    find('.btn.btn-secondary.btn-hover--jade.float-right').click
    expect(page.has_text?("Gefahrensymbol anlegen")).to be_truthy
    fill_in "danger_name", with: "TestName"
    fill_in "danger_label", with: "TestLabel"
    attach_file("danger_file", image, visible: false)
    find('input[value="Speichern"]').click
    expect(page.has_text?("Gefahrensymbol wurde erstellt")).to be_truthy
    visit "/dangers"
    expect(page.html.include?("/uploads/dangers/original/1.jpg")).to be_truthy
    expect(page.has_text?("TestName")).to be_truthy
  end

  it "bearbeiten", js: true do
    sign_in user
    Fabricate :danger
    visit "/dangers"
    page.all('.btn.btn-secondary.btn-hover--jade')[1].click
    fill_in "danger_name", with: "TestDangerNew"
    attach_file("danger_file", image, visible: false)
    find('input[value="Speichern"]').click
    expect(page.has_text?("Gefahrensymbol wurde bearbeitet")).to be_truthy
    visit "/dangers"
    expect(page.has_text?("TestDangerNew")).to be_truthy
  end

  it "löschen" do
    sign_in user
    Fabricate :danger
    visit "/dangers"
    expect(page.has_text?("TestGefahr")).to be_truthy
    accept_alert('Sind Sie sicher?') do
      find('a[class="btn btn-danger"]').click
    end
    expect(page.has_text?("Gefahrensymbol wurde gelöscht")).to be_truthy
    expect(page.has_text?("TestGefahr")).to be_falsey
  end

  it "Zuordnung anlegen" do
    sign_in user
    Fabricate :danger
    Fabricate :experiment
    visit "/experiments/1/edit"
    select "TestGefahr", from: "experiment_experiment_danger_assignments_attributes_0_danger_id"
    find('#experiment-save').click
    expect(page.has_text?("Experiment wurde bearbeitet")).to be_truthy
    # expect(page.has_text?("TestGefahr")).to be_truthy
    expect(page.html.include?("/uploads/dangers/medium/1.png")).to be_truthy
  end

  it "Zuordnung ändern" do
    sign_in user
    Fabricate :experiment_danger_assignment
    newdanger
    visit "/experiments/1/edit"
    select "TestGefahrNew", from: "experiment_experiment_danger_assignments_attributes_0_danger_id"
    find('#experiment-save').click
    # expect(page.has_text?("TestGefahr")).to be_truthy
    expect(page.html.include?("/uploads/dangers/medium/2.png")).to be_truthy
  end

  it "Zuordnung löschen" do
    pending 'Löschen geht nicht'
    # @vincent.thelang
    sign_in user
    Fabricate :experiment_danger_assignment
    visit "/experiments/1/edit"
    siehe andere experimente mit loeschen
  end

  it "Leere Felder beim Anlegen" do
    sign_in user
    visit "/dangers/new"
    expect(page.has_text?("Gefahrensymbol anlegen")).to be_truthy
    fill_in "danger_name", with: "TestGefahr"
    find('input[value="Speichern"]').click
    expect(page.has_text?("Bitte überprüfen Sie die folgenden Felder:")).to be_truthy
  end
end
