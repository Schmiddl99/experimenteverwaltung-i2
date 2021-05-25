require 'rails_helper'
describe "Experiment", js_errors: false do
  let(:user) { Fabricate :user }
  let(:sub_category) { Fabricate :sub_category }
  let(:experiment) { Fabricate :experiment, label: 'TestLabel.01', name: 'Test2' }
  let(:random) { Faker::Config.random }

  it "anlegen" do
    sign_in user
    Fabricate :sub_category
    visit "/experiments/new"
    expect(page.has_text?("Experiment anlegen")).to be_truthy
    fill_in "experiment_name", with: "TestName"
    fill_in "experiment_label", with: sub_category.label
    fill_in "experiment_description", with: "TestLabel"
    find('#experiment-save').click
    visit "/experiments"
    expect(page.has_text?("TestName")).to be_truthy
  end

  it "bearbeiten" do
    sign_in user
    Fabricate :experiment
    visit "/experiments/1/edit"
    fill_in "experiment_name", with: "TestNameNew"
    find('#experiment-save').click
    expect(page.has_text?("TestNameNew")).to be_truthy
  end

  it "löschen" do
    sign_in user
    Fabricate :experiment
    visit "/experiments/1"
    accept_alert('Sind Sie sicher?') do
      find('.dropdown-bin--red').click
    end
    expect(page.has_text?('TestExperiment')).to be_falsey
  end

  it "endgültig löschen" do
    sign_in user
    Fabricate :experiment
    visit "/experiments/1"
    accept_alert('Sind Sie sicher?') do
      find('.dropdown-bin--red').click
    end
    visit "/experiments/trash"
    expect(page.has_text?('TestExperiment')).to be_truthy
    accept_alert('Sind Sie sicher?') do
      find('a[class="btn btn-danger"]').click
    end
    expect(page.has_text?('TestExperiment')).to be_falsey
  end

  it "wiederherstellen" do
    sign_in user
    Fabricate :experiment
    visit "/experiments/1"
    accept_alert('Sind Sie sicher?') do
      find('.dropdown-bin--red').click
    end
    visit "/experiments/trash"
    sleep 1
    accept_alert('Wirklich wiederherstellen ?') do
      page.all('.btn.btn-secondary.btn-hover--jade')[0].click
    end
    visit "/experiments/trash"
    expect(page.has_text?('TestExperiment')).to be_falsey
    visit "/experiments/1"
    expect(page.has_text?('TestExperiment')).to be_truthy
  end

  it "Leere Felder beim Anlegen" do
    sign_in user
    visit "/experiments/new"
    expect(page.has_text?("Experiment anlegen")).to be_truthy
    fill_in "experiment_name", with: "TestName"
    fill_in "experiment_label", with: "TestLabel"
    find('#experiment-save').click
    expect(page.has_text?("Bitte überprüfen Sie die folgenden Felder:")).to be_truthy
  end

  it "download" do
    sign_in user
    Fabricate :experiment
    visit "/experiments/1.pdf"
    # wie test?
  end

  it "vor und zurück" do
    sign_in user
    Fabricate :experiment
    experiment
    visit "/experiments/1"
    expect(page.has_text?("TestExperiment")).to be_truthy
    find('i.fa.fs.fa-arrow-left').click
    expect(page.has_text?("Test2")).to be_truthy
    find('i.fa.fs.fa-arrow-right').click
    expect(page.has_text?("TestExperiment")).to be_truthy
  end

  it "über Sub_Category ausählen" do
    sign_in user
    Fabricate :experiment
    visit "/sub_categories/1"
    expect(page.has_text?("TestExperiment")).to be_truthy
    find('.stretched-link').click
    expect(page.has_text?("TestExperiment")).to be_truthy
  end
end
