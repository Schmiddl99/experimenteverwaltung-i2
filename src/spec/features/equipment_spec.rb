require 'rails_helper'
describe "Equipment", js_errors: false do
  let(:user) { Fabricate :user }
  let(:random) { Faker::Config.random }
  let(:neweqipment) { Fabricate :equipment, name: "TestEquipmentNew" }

  it "anlegen" do
    sign_in user
    Fabricate :experiment
    visit "/equipment"
    find('.btn.btn-secondary.btn-hover--jade.pull-right').click
    expect(page.has_text?("Gerät anlegen")).to be_truthy
    fill_in "equipment_name", with: "TestName"
    fill_in "equipment_location", with: "TestLocation"
    fill_in "equipment_inventory_nr", with: "TestNr"
    find('input[value="Speichern"]').click
    expect(page.has_text?("Gerät wurde erstellt")).to be_truthy
    expect(page.has_text?("TestName")).to be_truthy
  end

  it "bearbeiten" do
    sign_in user
    Fabricate :equipment
    visit "/equipment"
    page.all('.btn.btn-secondary.btn-hover--jade')[1].click
    fill_in "equipment_name", with: "TestEquipmentNew"
    find('input[value="Speichern"]').click
    expect(page.has_text?("Gerät wurde bearbeitet")).to be_truthy
    expect(page.has_text?("TestEquipmentNew")).to be_truthy
  end

  it "löschen" do
    sign_in user
    Fabricate :equipment
    visit "/equipment"
    expect(page.has_text?("TestEquipment")).to be_truthy
    accept_alert('Sind Sie sicher?') do
      find('a[class="btn btn-sm btn-danger"]').click
    end
    expect(page.has_text?("Gerät wurde gelöscht")).to be_truthy
    expect(page.has_text?("TestEquipment")).to be_falsey
  end

  it "Zuordnung anlegen" do
    sign_in user
    Fabricate :equipment
    Fabricate :experiment
    visit "/experiments/1/edit"
    select "TestEquipment", from: "experiment_experiment_equipment_assignments_attributes_0_equipment_id"
    find('#experiment-save').click
    expect(page.has_text?("TestEquipment")).to be_truthy
  end

  it "Zuordnung ändern" do
    sign_in user
    Fabricate :experiment_equipment_assignment
    neweqipment
    visit "/experiments/1/edit"
    select "TestEquipmentNew", from: "experiment_experiment_equipment_assignments_attributes_0_equipment_id"
    find('#experiment-save').click
    expect(page.has_text?("TestEquipmentNew")).to be_truthy
    expect(page.has_text?("TestEquipment ")).to be_falsey
  end

  it "Zuordnung löschen" do
    pending 'Löschen geht nicht'
    # @vincent.thelang
    sign_in user
    Fabricate :experiment_equipment_assignment
    visit "/experiments/1/edit"
    siehe andere experimente mit loeschen
  end

  it "Leere Felder beim Anlegen" do
    sign_in user
    visit "/equipment/new"
    expect(page.has_text?("Gerät anlegen")).to be_truthy
    fill_in "equipment_name", with: "TestEquipment"
    find('input[value="Speichern"]').click
    expect(page.has_text?("Bitte überprüfen Sie die folgenden Felder:")).to be_truthy
  end
end
