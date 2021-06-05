require 'rails_helper'
describe "Book_experiment", js_errors: false do
  let(:random) { Faker::Config.random }
  let(:password) { Faker::Config.random }
  let(:lecturer) { Fabricate :user, password: password, role: :lecturer }
  let(:subcat) {Fabricate :sub_category }
  let(:experiment_1) { Fabricate :experiment, name: 'test_experiment_1',label: 'test_label_1',sub_category:subcat }
  let(:experiment_2) { Fabricate :experiment, name: 'test_experiment_2',label: 'test_label_2',sub_category:subcat }
  let(:experiment_3) { Fabricate :experiment, name: 'test_experiment_3',label: 'test_label_3',sub_category:subcat }
  let(:valid_time) {'12:00'}
  let(:invalid_time) {Array['12:61','25:01','24:61']}
  let(:comment) {'Kommentar'}
  let(:name_dummy_experiment) {'manuell eingefügtes Experiment 1'}
  
  before(:each) do
    Fabricate :course
    page.windows[0].maximize
    sign_in lecturer
    visit "/checkout/new"
    find('#order_course_id').find(:xpath, 'option[2]').select_option
  end
  
  #TC01
  #after signing the lecturer starts his order with valid parameters and orders 3 experiments
  #in the checkout menu he enters a comment and deletes one experiment
  #TODO check for correctness in journal
  it "erfolgreich buchen" do
    experiment_1
    experiment_2
    experiment_3
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")    #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                       #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    for i in 1..3 do
      sleep(0.3)
      find(:xpath,"(//div[@class='list-group']/div[#{i}]/a/i)").click
    end
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                    #zum Buchungsabschluss
    find(:xpath,"(//i[@class='fas fa-shopping-cart'])[1]").click                     #remove experiment 1
    find(:xpath,"//textarea").set(comment)
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click             #buchung abschließen
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy
    #TODO check for correctnes -> journal
  end

  #TC02a
  #after signing in the lecturer trys to start an order with invalid time parameter
  it "invalide Zeit verhindern" do
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")
    invalid_time.each do |inval_time|
      find(:xpath,"//input[@id='order_course_at_time']").set(inval_time)
      find(:xpath,"//input[@class='btn btn-primary mr-2']").click                           #click 'weiter zu den experimenten'
      expect(page.has_text?("Buchung konnte nicht gestartet werden! Bitte korrigieren Sie Ihre Angaben.")).to be_truthy
    end
  end

  #TC02b
  #after signing in the lecturer trys to start an order with invalid date parameter
  it "invalides Datum verhindern" do
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '-1d')")
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                      #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                             #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung konnte nicht gestartet werden! Bitte korrigieren Sie Ihre Angaben.")).to be_truthy
  end

  #TC03
  #after signing in the lecturer tries to complete the order without any orderered experiment
  #expected: checkout btn is disabled
  it "leere Buchung verhindern" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")    #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                       #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    expect(page.has_xpath?("//a[@class='btn btn-secondary d-block disabled']")).to be_truthy    #btn disabled -> kann nicht gebucht werden
  end

  #TC04
  #after signing in the lecturer orders on experiment an tries to order the same experiment again
  #expected: after first time order checkout btn is enabled
  #          after second time order of the same experiment btn get disabled 
  #double odering is not possible as clicking again results in removing the experiment from the order list
  it "leere Buchung verhindern" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")    #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                       #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                      #order experiment1
    expect(page.has_xpath?("//a[@class='btn btn-secondary d-block disabled']")).to be_falsy    #btn disabled -> kann nicht gebucht werden
    expect(page.has_xpath?("//a[@class='btn btn-secondary d-block']")).to be_truthy
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                      #clicking again -> gets removed from order list
    expect(page.has_xpath?("//a[@class='btn btn-secondary d-block disabled']")).to be_truthy    #btn disabled -> kann nicht gebucht werden
    expect(page.has_xpath?("//a[@class='btn btn-secondary d-block']")).to be_falsy
  end

  #TC05
  #after signing in the lecturer orders on experiment and the decides to abort the orderprocess
  it "Buchung abbrechen möglich" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")    #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                       #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                      #order experiment1
    accept_alert('Wollen Sie die Buchung wirklich abbrechen?') do
      find(:xpath,"//a[@class='btn btn-light mt-2']").click                            #buchung abbrechen
    end
    expect(page.has_text?("Buchung erfolgreich abgebrochen!")).to be_truthy
  end

  #TC06
  #after signing in the lecturer orders a dummyexperiment and succesfully checks out
  it "Dummyexperiment buchen möglich" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")    #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                       #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"//button[@class='btn btn-secondary d-block mt-2']").click             #experiment manuell hinzufügen
    find(:xpath,"//input[@id='dummy_experiment_name']").set(name_dummy_experiment)     #name des dummyexperiment
    find(:xpath,"//input[@value='Experiment hinzufügen']").click                       #experiment hunzufügen
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                      #zum Buchungsabschluss
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click               #buchung abschließen
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy
    #todo check im journal
  end

  #TC07a
  #after signing in the lecturer orders a dummyexperiment and then orders a regular Experiment
  it "Dummyexperiment bevor regulärem buchen" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")    #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                       #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"//button[@class='btn btn-secondary d-block mt-2']").click             #experiment manuell hinzufügen
    find(:xpath,"//input[@id='dummy_experiment_name']").set(name_dummy_experiment)     #name des dummyexperiment
    find(:xpath,"//input[@value='Experiment hinzufügen']").click                       #dummyexperiment hinzufügen
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                       #order experiment1
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                      #zum Buchungsabschluss
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click               #buchung abschließen
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy
    #todo check im journal
  end

  #TC07b
  #after signing in the lecturer orders a regular Experiment and then a dummyexperiment
  it "regulär bevor Dummyexperiment buchen" do
    experiment_1
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")    #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                       #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    find(:xpath,"(//div[@class='list-group']/div[1]/a/i)").click                       #order experiment1
    find(:xpath,"//button[@class='btn btn-secondary d-block mt-2']").click             #experiment manuell hinzufügen
    find(:xpath,"//input[@id='dummy_experiment_name']").set(name_dummy_experiment)     #name des dummyexperiment
    find(:xpath,"//input[@value='Experiment hinzufügen']").click                       #dummyexperiment hinzufügen
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                      #zum Buchungsabschluss
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click               #buchung abschließen
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy
    #todo check im journal
  end

  #TC08
  #after signing the lecturer starts his order with valid parameters and orders 2 experiments
  #in the checkout menu he switches the sequenze of his orders
  it "Reihenfolge tauschen" do
    experiment_1
    experiment_2
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+7d')")    #insert date today +7d
    find(:xpath,"//input[@id='order_course_at_time']").set(valid_time)                #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                       #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    for i in 1..2 do
      sleep(0.3)
      find(:xpath,"(//div[@class='list-group']/div[#{i}]/a/i)").click
    end
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                    #zum Buchungsabschluss
    source=find(:xpath,"//div[@id='1']")                                             #das 1 experiment wählen
    target=find(:xpath,"//textarea")                                                  # element weit unten
    source.drag_to(target,delay:1)
    binding.pry
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click             #buchung abschließen
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy
    #TODO check for correctnes -> journal
  end



  
  



end