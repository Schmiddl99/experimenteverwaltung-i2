require 'rails_helper'
describe "Experiment", js_errors: false do
  let(:user) { Fabricate :user }
  let(:sub_category) { Fabricate :sub_category }
  let(:experiment) { Fabricate :experiment, label: 'TestLabel.01', name: 'Test2' }
  let(:random) { Faker::Config.random }

  before(:each) do
    page.windows[0].maximize
  end 

  
  #4 Equipments are created "Pendel,Peitsche,Achse,Bus"
  #user signs in as admin and visits "Experimente anlegen"
  #for adding equipment he uses the filter
  #he types in "b"
  #it is expected that only one Result ("Bus") is shown
  it "Geräteauswahl filtern ein Match" do
    sign_in user
    Fabricate :sub_category
    Fabricate :equipment, name: "Pendel"
    Fabricate :equipment, name: "Peitsche"
    Fabricate :equipment, name: "Achse"
    Fabricate :equipment, name: "Bus"
    visit "/experiments/new"
    find(:xpath,"//div[@class='filter-option-inner-inner']").click                                             #click "Gerät hinzufügen"
    find(:xpath,"//input[@type='search'and @class='form-control']").set('b')                                   #type in 'b'
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Bus")).to be_truthy                    
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Pendel")).to be_falsey
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Peitsche")).to be_falsey
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Achse")).to be_falsey
  end

  #4 Equipments are created "Pendel,Peitsche,Achse,Bus"
  #user signs in as admin and visits "Experimente anlegen"
  #for adding equipment he uses the filter
  #he types in "p"
  #it is expected that two Results ("Peitsche" and "Pendel") are shown
  it "Geräteauswahl filtern zwei Matches" do
    sign_in user
    Fabricate :sub_category
    Fabricate :equipment, name: "Pendel"
    Fabricate :equipment, name: "Peitsche"
    Fabricate :equipment, name: "Achse"
    Fabricate :equipment, name: "Bus"
    visit "/experiments/new"
    find(:xpath,"//div[@class='filter-option-inner-inner']").click                                              #click "Gerät hinzufügen"
    find(:xpath,"//input[@type='search'and @class='form-control']").set('p')                                    #type in 'p'
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Bus")).to be_falsey                            
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Pendel")).to be_truthy
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Peitsche")).to be_truthy
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Achse")).to be_falsey
  end

  #4 Equipments are created "Pendel,Peitsche,Achse,Bus"
  #user signs in as admin and visits "Experimente anlegen"
  #for adding equipment he uses the filter
  #he types in "x"
  #it is expected that in the filter the message "Keine Ergbenisse für x" is shown
  #and it is expected that no other results are shown
  it "Geräteauswahl filtern kein Match" do
    sign_in user
    Fabricate :sub_category
    Fabricate :equipment, name: "Pendel"
    Fabricate :equipment, name: "Peitsche"
    Fabricate :equipment, name: "Achse"
    Fabricate :equipment, name: "Bus"
    visit "/experiments/new"
    find(:xpath,"//div[@class='filter-option-inner-inner']").click                                            #click "Gerät hinzufügen"
    find(:xpath,"//input[@type='search'and @class='form-control']").set('x')                                  #type in 'x' ->no item matches 'x'
    expect(find(:xpath,"//div[@class='inner show']").has_text?('Keine Ergebnisse für "x"')).to be_truthy
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Bus")).to be_falsey                            
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Pendel")).to be_falsey
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Peitsche")).to be_falsey
    expect(find(:xpath,"//div[@class='inner show']").has_text?("Achse")).to be_falsey
  end

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
    expect(page.has_text?("Experiment wurde gelöscht")).to be_truthy
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
    expect(page.has_text?("Experiment wurde gelöscht")).to be_truthy
    visit "/experiments/trash"
    accept_alert('Wirklich wiederherstellen ?') do
      page.all('.btn.btn-secondary.btn-hover--jade')[0].click
    end
    expect(page.has_text?("Experiment wurde wiederhergestellt")).to be_truthy
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

    #changed '.stretched-link' to flex-grow-1
  it "über Sub_Category auswählen" do
    sign_in user
    Fabricate :experiment
    visit "/sub_categories/1"
    expect(page.has_text?("TestExperiment")).to be_truthy
    find('.flex-grow-1').click
    expect(page.has_text?("TestExperiment")).to be_truthy
  end
end
