#@author Piet Gutsche
require 'rails_helper'
require 'date'

describe "Journal", js_errors: false do
  let(:random) { Faker::Config.random }
  let(:password) { Faker::Config.random }
  let(:lecturer) { Fabricate :user, password: password, role: :lecturer }
  let(:admin) { Fabricate :user }
  let(:order) { Fabricate :order,user:lecturer }
  let(:past_date) { Date.current - 5.day }
      
  before(:each) do
    page.windows[0].maximize
  end 
  
  #after signing in as lecturer, the user visits his journal (no orders had been created)
  #it is expected that a message is shown that no orders had been created
  it "das leere Journal wird angezeigt" do
    sign_in lecturer
    visit "journal"
    expect(page.has_text?("Sie haben noch keine Buchung getätigt.")).to be_truthy
  end

  #3 orders are created
  #order_1 is actual day + 1, order_2 actual day + 2 and order_3 is actual day + 3
  #after signing in as lecturer, the user visits his journal
  #it is expected that order_1 is sorted to the first position order_2 2nd and order_3 3rd
  it "Journal enthält chronologische geordnete Buchungen" do
    Fabricate :order, user: lecturer, course_at_date:Date.current + 3.day
    Fabricate :order, user: lecturer, course_at_date:Date.current + 1.day                         #fabricate orders unsorted
    Fabricate :order, user: lecturer, course_at_date:Date.current + 2.day
    sign_in lecturer
    visit "journal"
    dates_arr=Array.new                                                                           #data structure to store the dates
    (0..2).each {|i| 
      txt=find(:xpath,"(//div[@id='ordersAccordion']/div/div/h2)[#{i+1}]")['textContent']         #get textcontent for each order
      start_of_date=txt.index(" am")+4                                                            #date is found between " am " and " um "
      end_of_date=txt.index(" um ")-1
      date_string=txt[start_of_date..end_of_date]                                                 #slicing out datestring
      dates_arr<<date_string.to_date                                                              
    }
    expect(dates_arr[2]).to be < dates_arr[1]                                                     #if chronologically sorted the oldest date is at last position
    expect(dates_arr[1]).to be < dates_arr[0]
  end


  #a order in the future is created
  #after signing in as lecturer, the user visits his journal
  #he clicks on editing his order
  #he adds one dummyexperiment with the name "experiment_2"
  #after checking out the changes he expands his edited order in the journal
  #it is expected that he "experiment_2" was added to this order
  it "Buchungen in der Zukunft können vom Journal aus bearbeitet werden" do
    order
    sign_in lecturer
    visit "journal"
    find(:xpath,"//a[@href='/journal/1/edit']").click
    expect(page.has_xpath?("//input[@value='Änderungen speichern']")).to be_truthy
    expect(page.has_xpath?("//input[@value='Bearbeitung abschließen']")).to be_truthy
    find(:xpath,"//a[contains(.,'hinzufügen')]").click                                                      #click "Experiment hinzufügen"
    find(:xpath,"//button[@class='btn btn-secondary d-block mt-2']").click                                  #click 'Experiment manuell hinzufügen'
    find(:xpath,"//input[@id='dummy_experiment_name']").set("experiment_2")                                 #name of dummyexperiment
    find(:xpath,"//input[@value='Experiment hinzufügen']").click 
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                                           #click 'zum Buchungsabschluss'
    find(:xpath,"//input[@name='persist']").click                                                           #click "Bearbeitung abschließen"
    expect(page.has_text?("Buchung erfolgreich aktualisiert!")).to be_truthy
    find(:xpath,"//button[@data-target='#order-1']").click                                                  #expand the order
    expect(page.has_text?("experiment_2")).to be_truthy
  end

  #a order in the future is created
  #after signing in as lecturer, the user visits his journal
  #he has one order on clicks on deleting (trash symbol)
  #after confirming his order is deleted
  #a message confirming the deletion and a empty journal is expected
  it "Buchungen in der Zukunft können vom Journal aus gelöscht werden" do
    order
    sign_in lecturer
    visit "journal"
    accept_alert('Möchten Sie diese Buchung wirklich löschen?') do
      find(:xpath,"//a[@data-method='delete'and @href='/journal/1']").click                                               
    end
    expect(page.has_text?("Die Buchung wurde erfolgreich gelöscht!")).to be_truthy
    expect(page.has_text?("Sie haben noch keine Buchung getätigt.")).to be_truthy
  end

  #a order in the past is created
  #after signing in as lecturer, the user visits his journal
  #as the only order is in the past, it is expected, that symbols and links for deleting and editing are not visible
  it "Buchungen in Vergangenheit könnne nicht bearbeitet werden" do
    Timecop.travel(past_date) do
        Fabricate :order, user: lecturer
    end
    sign_in lecturer
    visit "journal"
    expect(page.has_xpath?("//a[@data-method='delete'and @href='/journal/1']")).to be_falsey
    expect(page.has_xpath?("//a[@href='/journal/1/edit']")).to be_falsey
  end

end