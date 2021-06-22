#@author Piet Gutsche
require 'rails_helper'
require 'date'

describe "Lecturer Week", js_errors: false do
  let(:random) { Faker::Config.random }
  let(:password) { Faker::Config.random }
  let(:lecturer) { Fabricate :user, password: password, role: :lecturer }
  let(:lecturer_2) { Fabricate :user, password: password, role: :lecturer }
  let(:admin) { Fabricate :user }
  let(:order) { Fabricate :order, user: lecturer }
  let(:order_2) { Fabricate :order,user: lecturer_2 }

    
  #creating one order that can be displayed 
  before(:each) do
    order
    page.windows[0].maximize
  end

  #after signing in as admin the user visits lecturers week to see orders of lecturers
  #one order in the actual week was fabricated (see before(:each)) 
  #after choosing the correct week he can show this order by clicking "Anzeigen"
  #the user is supposed to see the actual order with the correct parameters(Experiment "Dummy Experiment")
  #and one comment ("Testkommentar")
  it "Dozentenwoche korrekt anzeigen als Admin" do
    sign_in admin
    visit "lecturer_week/new"
    week = (Date.today + 1.day).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(page.has_text?("Dummy Experiment")).to be_truthy
    expect(page.has_text?("Testkommentar")).to be_truthy
  end

  #after signing in as admin the user visits lecturers week to see orders of lecturers
  #one order for each lecturer in the actual week was fabricated (see before(:each)) 
  #after choosing the correct week he can show the order of the 1st lecturer by clicking "Anzeigen"
  #the user is supposed to see the actual order with the correct parameters(Experiment "Dummy Experiment")
  #and one comment ("Testkommentar")
  #he clicks on "Zurück" and chooses the other lecturer and displays his week
  #the user is supposed to see the actual order with the correct parameters(Experiment "Dummy Experiment")
  #and one comment ("Testkommentar")
  it "Dozentenwoche korrekt anzeigen als Admin mehrere Dozenten" do
    order_2
    sign_in admin
    visit "lecturer_week/new"
    week = (Date.today + 1.day).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(page.has_text?("Dummy Experiment")).to be_truthy
    expect(page.has_text?("Testkommentar")).to be_truthy
    find(:xpath,"//a[@class='btn btn-secondary float-left']").click                       #click "Zurück"
    find(:xpath,"//select[@id='lecturer_week_lecturer_id']/option[2]").select_option      #select the other lecturer
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(page.has_text?("Dummy Experiment")).to be_truthy
    expect(page.has_text?("Testkommentar")).to be_truthy
  end

  #after signing in as admin the user visits lecturers week to see orders of lecturers
  #one order in the actual week was fabricated (see before(:each)) 
  #after choosing the correct week he can show this order by clicking "Anzeigen"
  #the user chooses to print the lecturers week
  #this test only checks if the correct system method(window.print()) is called when "drucken" gets clicked
  #testing if printing worked correctly has to be done manually
  #see test_cases.adoc TCxx 
  it "Dozentenwoche drucken als Admin" do
    sign_in admin
    visit "lecturer_week/new"
    week = (Date.today + 1.day).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(find_button("Drucken")[:onclick]). to eq("window.print();")       #check if "Drucken" button exist and the system printing menu gets called onclick
  end

  #after signing in as lecturer the user visits lecturers week to see his orders
  #one order in the actual week was fabricated (see before(:each)) 
  #after choosing the correct week he can show this order by clicking "Anzeigen"
  #the user is supposed to see the actual order with the correct parameters(Experiment "Dummy Experiment")
  #and one comment ("Testkommentar")
  it "Dozentenwoche korrekt anzeigen als Dozent" do
    sign_in lecturer
    visit "lecturer_week/new"
    week = (Date.today+1.to_i.days).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(page.has_text?("Dummy Experiment")).to be_truthy
    expect(page.has_text?("Testkommentar")).to be_truthy
  end

  #after signing in as lecturer the user visits lecturers week to see his orders
  #one order in the actual week was fabricated (see before(:each)) 
  #after choosing the correct week he can show this order by clicking "Anzeigen"
  #the user chooses to print his lecturers week
  #this test only checks if the correct system method(window.print()) is called when "drucken" gets clicked
  #testing if printing worked correctly has to be done manually
  #see test_cases.adoc TCxx 
  it "Dozentenwoche drucken als Dozent" do
    sign_in lecturer
    visit "lecturer_week/new"
    week = (Date.today+1.to_i.days).cweek
    find(:xpath,"//select[@id='lecturer_week_week']/option[contains(.,'KW #{week}')]").select_option
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(find_button("Drucken")[:onclick]). to eq("window.print();")       #check if "Drucken" button exist and the system printing menu gets called onclick
  end
  
end
