#@author Piet Gutsche
require 'rails_helper'
require 'date'

describe "Lasttest", js_errors: false do
  let(:random) { Faker::Config.random }
  let(:password) { Faker::Config.random }
  let(:lecturer) { Fabricate :user, password: password, role: :lecturer }
  let(:subcat) {Fabricate :sub_category }
  let(:experiment_1) { Fabricate :experiment, name: 'test_experiment_1',label: 'test_label_1',sub_category:subcat }
  let(:experiment_2) { Fabricate :experiment, name: 'test_experiment_2',label: 'test_label_2',sub_category:subcat }
  let(:experiment_3) { Fabricate :experiment, name: 'test_experiment_3',label: 'test_label_3',sub_category:subcat }
  let(:admin) { Fabricate :user }
  let(:order) { Fabricate :order,user:lecturer }
  let(:past_date) { Date.current - 5.day }
      
  before(:each) do
    Fabricate :course
    page.windows[0].maximize
  end 
  
  #2000 orders are created to simulate the database after 2+years of usage
  #user signs in as lecturer and orders some experiments
  #in the checkout process he deletes one and the finishs his order
  #he then visits the journal 
  #it is expected no errors and delay occurs and the order gets correctly completed
  it "2000 Buchungen verhindern nicht eine neue Buchung" do
    experiment_1
    experiment_2
    experiment_3
    (2..102).each {|i| 
     (8..18).each do { |hr| 
        Fabricate :order, user: lecturer, course_at_date: Date.current + i.day, course_at_time: "#{hr}:00"
      }  
    }
    sign_in lecturer
    visit "/checkout/new"
    find('#order_course_id').find(:xpath, 'option[2]').select_option
    page.execute_script("$('#order_course_at_date').datepicker('setDate', '+1d')")                      #insert date today +1d
    find(:xpath,"//input[@id='order_course_at_time']").set('12:00')                                      #insert time
    find(:xpath,"//input[@class='btn btn-primary mr-2']").click                                         #click 'weiter zu den experimenten'
    expect(page.has_text?("Buchung erfolgreich gestartet!")).to be_truthy
    visit "/sub_categories/1"
    for i in 1..3 do
      sleep(0.3)
      find(:xpath,"(//div[@class='list-group']/div[#{i}]/a/i)").click
    end
    find(:xpath,"//a[contains(.,'zum Buchungsabschluss')]").click                                       #click 'zum Buchungsabschluss'
    find(:xpath,"(//i[@class='fas fa-trash-alt'])[1]").click                                            #remove experiment 1
    find(:xpath,"//textarea").set('ein anderer Kommentar')
    find(:xpath,"//input[contains(@value,'Buchung abschließen')]").click                                #click 'Buchung abschließen'
    expect(page.has_text?("Ihre Buchung wurde gespeichert!")).to be_truthy   
    visit "journal"
    find(:xpath,"//a[@href='/journal?page=112']").click                                               #go to last page as our order is "oldest"
    find(:xpath,"//button[@data-target='#order-1112']").click                                           #expand our order
    expect(page.has_text?(" test_label_2 - test_experiment_2")).to be_truthy
    expect(page.has_text?("Kommentar zur Buchung: ein anderer Kommentar")).to be_truthy
    expect(page.has_text?(" test_label_3 - test_experiment_3")).to be_truthy
  end
end

 
