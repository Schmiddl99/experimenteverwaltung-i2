#@author Piet Gutsche
require 'rails_helper'
require 'date'
describe "Book_experiment", js_errors: false do
  let(:random) { Faker::Config.random }
  let(:password) { Faker::Config.random }
  let(:lecturer) { Fabricate :user, password: password, role: :lecturer }
  let(:subcat) {Fabricate :sub_category }
  let(:experiment_1) { Fabricate :experiment, name: 'test_experiment_1',label: 'test_label_1',sub_category:subcat }
  let(:experiment_2) { Fabricate :experiment, name: 'test_experiment_2',label: 'test_label_2',sub_category:subcat }
  let(:experiment_3) { Fabricate :experiment, name: 'test_experiment_3',label: 'test_label_3',sub_category:subcat }
  let(:valid_time) {'12:00'}
  let(:invalid_time) {Array['12:61','25:01','24:61','foo','11']}
  let(:comment) {'Kommentar'}
  let(:name_dummy_experiment) {'manuell eingefügtes Experiment 1'}
  let(:days_in_future) {'7'}
  
  before(:each) do
    Fabricate :course
    page.windows[0].maximize
    sign_in lecturer
    visit "/checkout/new"
    find('#order_course_id').find(:xpath, 'option[2]').select_option
  end
  
  #TC01
  #after signing in the lecturer starts his order with valid parameters and orders 3 experiments
  #in the checkout menu he enters a comment and deletes one experiment
  #expected:in the lecturer week the 2 remaininig experiments are shown
  it "erfolgreich buchen" do
    experiment_1
    experiment_2
    experiment_3
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+#{days_in_future}d')")      #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                  #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                         #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    for i in 1..3 do
      sleep(0.3)
      find(:xpath,"(//div[@class='list-group']/div[#{i}]/a/i)").click
    end
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                                       #click 'zum Buchungsabschluss'
    find(:xpath,"(//i[@class='fas fa-trash-alt'])[1]").click                                        #remove experiment 1
    find(:xpath,"//textarea").set(comment)
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click                                #click 'Buchung abschließen'
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy            
    visit "/lecturer_week/new"                                                                          #check in lecturer week
    week = (Date.today+days_in_future.to_i.days).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option    #choose week 
    find(:xpath,"//input[@value='Anzeigen']").click                                                     #show
    expect(page.has_css?("ol li:nth-child(1)",text:'test_label_2 test_experiment_2')).to be_truthy
    expect(page.has_css?("ol li:nth-child(2)",text:'test_label_3 test_experiment_3')).to be_truthy
  end

  #TC02a
  #after signing in the lecturer trys to start an order with invalid time parameter
  #expected: error message for invalid time
  it "invalide Zeit verhindern" do
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")
    invalid_time.each do |inval_time|                                                                   #try for every option given in array invalid_time
      find(:xpath,"//input[@id='order_course_at_time']").set(inval_time)                                #enter invalid time
      find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                       #click 'weiter zu den experimenten'
      expect(page.has_text?("Buchung konnte nicht gestartet werden! Bitte korrigieren Sie Ihre Angaben.")).to be_truthy
    end
  end

  #TC02b
  #after signing in the lecturer trys to start an order with invalid date parameter
  #it is simulated that he clicks on yesterday -> datepicker has yesterday as hidden/not active
  #expected: error message for invalid date as because the field is empty after clicking on a field in the past
  it "invalides Datum verhindern -click" do
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '-1d')")                       #try to start an order yesterday
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                   #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                          #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung konnte nicht gestartet werden! Bitte korrigieren Sie Ihre Angaben.")).to be_truthy
  end

  #TC02b
  #after signing in the lecturer trys to start an order with invalid date parameter
  #he writes the date of yesterday into the field
  #expected: error message for invalid date as because the field is empty after clicking on a field in the past
  it "invalides Datum verhindern -eingabe" do
    fill_in('Datum', with: Date.yesterday.to_s)                                                                 #try to start an order yesterday
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                   #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                          #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung konnte nicht gestartet werden! Bitte korrigieren Sie Ihre Angaben.")).to be_truthy
  end

  #TC03
  #after signing in the lecturer tries to complete the order without any orderered experiment
  #expected: checkout btn is disabled
  it "leere Buchung verhindern" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")                        #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                    #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                           #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    expect(page.has_xpath?("//a[@class='btn mb-2 btn-secondary d-block disabled']")).to be_truthy              #btn disabled -> order completion not possible
  end

  #TC04
  #after signing in the lecturer orders on experiment an tries to order the same experiment again
  #expected: after first time order checkout btn is enabled
  #          after second time order of the same experiment btn get disabled 
  #          ->double odering is not possible as clicking again results in removing the experiment from the order list
  it "doppelte Buchung verhindern" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")                        #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                    #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                           #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                                          #order experiment1
    sleep(0.3)
    expect(page.has_xpath?("//a[@class='btn mb-2 btn-secondary d-block disabled']")).to be_falsy               #btn disabled -> kann nicht gebucht werden
    expect(page.has_xpath?("//a[@class='btn mb-2 btn-secondary d-block']")).to be_truthy
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                                          #clicking again -> gets removed from order list
    expect(page.has_xpath?("//a[@class='btn mb-2 btn-secondary d-block disabled']")).to be_truthy              #btn disabled -> order completion not possible
    expect(page.has_xpath?("//a[@class='btn mb-2 btn-secondary d-block']")).to be_falsy
  end

  #TC05
  #after signing in the lecturer orders on experiment and the decides to abort the orderprocess
  #expected:message that orderprocess was aborted
  it "Buchung abbrechen möglich" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")                        #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                    #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                           #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                                          #order experiment1
    accept_alert('Wollen Sie die Buchung wirklich abbrechen?') do
      find(:xpath,"//a[@class='btn btn-light']").click                                               #click 'Buchung abbrechen'
    end
    expect(page.has_text?("Buchung erfolgreich abgebrochen!")).to be_truthy
  end

  #TC06
  #after signing in the lecturer orders a dummyexperiment and succesfully checks out
  #expected: an order with the dummyexperiment can be seen in the lecturers week
  it "Dummyexperiment buchen möglich" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")                         #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                     #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                            #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"//button[@class='btn btn-secondary d-block mt-2']").click                                 #experiment manuell hinzufügen
    find(:xpath,"//input[@id='dummy_experiment_name']").set(name_dummy_experiment)                         #insert name of dummyexperiment
    find(:xpath,"//input[@value='Experiment hinzufügen']").click                                           #click 'Experiment hinzufügen'
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                                          #click 'zum Buchungsabschluss'
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click                                   #click 'Buchung abschließen'
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy
    visit "/lecturer_week/new"                                                                             #check in lecturer week
    week = (Date.today+days_in_future.to_i.days).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option       #insert week of order
    find(:xpath,"//input[@value='Anzeigen']").click                                                        #click 'Anzeigen'
    expect(page.has_css?("ol li:nth-child(1)",text:'manuell eingefügtes Experiment 1')).to be_truthy
  end

  #TC07a
  #after signing in the lecturer orders a dummyexperiment and then orders a regular Experiment
  #expected: an order with the dummyexperiment(1) and regular experiment(2) can be seen in the lecturer week
  it "Dummyexperiment bevor regulärem buchen" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")                        #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                    #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                           #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"//button[@class='btn btn-secondary d-block mt-2']").click                                 #click 'Experiment manuell hinzufügen'
    find(:xpath,"//input[@id='dummy_experiment_name']").set(name_dummy_experiment)                         #insert name of dummyexperiment
    find(:xpath,"//input[@value='Experiment hinzufügen']").click                                           #dummyexperiment hinzufügen
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                                           #order experiment1
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                                          #click 'zum Buchungsabschluss'
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click                                   #click 'Buchung abschließen'
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy
    visit "/lecturer_week/new"                                                                             #check in lecturer week
    week = (Date.today+days_in_future.to_i.days).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option       #insert week of order
    find(:xpath,"//input[@value='Anzeigen']").click                                                        #click 'Anzeigen' 
    expect(page.has_css?("ol li:nth-child(1)",text:'manuell eingefügtes Experiment 1')).to be_truthy
    expect(page.has_css?("ol li:nth-child(2)",text:'test_label_1 test_experiment_1')).to be_truthy
  end

  #TC07b
  #after signing in the lecturer orders a regular Experiment and then a dummyexperiment
  #expected: an order with the dummyexperiment(2) and regular experiment(1) can be seen in the lecturer week
  it "regulär bevor Dummyexperiment buchen" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")                          #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                      #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                             #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                                            #order experiment1
    expect(page.has_text?("Experiment erfolgreich zur Buchung hinzugefügt")).to be_truthy
    find(:xpath,"//button[@class='btn btn-secondary d-block mt-2']").click                                  #click 'Experiment manuell hinzufügen'
    expect(page.has_text?("Manuell Experiment hinzufügen")).to be_truthy
    find(:xpath,"//input[@id='dummy_experiment_name']").set(name_dummy_experiment)                          #name of dummyexperiment
    find(:xpath,"//input[@value='Experiment hinzufügen']").click                                            
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                                           #click 'zum Buchungsabschluss'
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click                                    #click 'Buchung abschließen'
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy
    visit "/lecturer_week/new"                                                                              #check in lecturer weel
    week = (Date.today+days_in_future.to_i.days).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option        #insert week of order
    find(:xpath,"//input[@value='Anzeigen']").click                                                         #click 'Anzeigen' 
    expect(page.has_css?("ol li:nth-child(1)",text:'test_label_1 test_experiment_1')).to be_truthy
    expect(page.has_css?("ol li:nth-child(2)",text:'manuell eingefügtes Experiment 1')).to be_truthy
    
  end

  #TC08
  #after signing the lecturer starts his order with valid parameters and orders 2 experiments
  #in the checkout menu he switches the sequenze of his orders
  #expected: in the journal experiment1 is the second and experiment2 is the first
  it "Reihenfolge tauschen" do
    experiment_1
    experiment_2
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")                          #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                                      #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                             #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    for i in 1..2 do
      sleep(0.3)
      find(:xpath,"(//div[@class='list-group']/div[#{i}]/a/i)").click
    end
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                                           #click 'zum Buchungsabschluss'
    source = find(:xpath,"//div[@id='1']")                                                                  #switch order of experiments
    target = find(:xpath,"//div[@id='2']")                                                                  
    source.drag_to(target,delay:1)                                                                          
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click                                    #click 'Buchung abschließen'
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy
    visit "/lecturer_week/new"                                                                              #check in lecturer week
    week = (Date.today+days_in_future.to_i.days).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option        #insert week
    find(:xpath,"//input[@value='Anzeigen']").click                                                         #click 'Anzeigen' 
    expect(page.has_css?("ol li:nth-child(1)",text:'test_label_2 test_experiment_2')).to be_truthy
    expect(page.has_css?("ol li:nth-child(2)",text:'test_label_1 test_experiment_1')).to be_truthy
  end
end
