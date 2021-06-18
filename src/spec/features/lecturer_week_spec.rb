#@author Piet Gutsche
require 'rails_helper'
require 'date'

describe "Lecturer Week", js_errors: false do
  let(:random) { Faker::Config.random }
  let(:password) { Faker::Config.random }
  let(:lecturer) { Fabricate :user, password: password, role: :lecturer }
  let(:admin) { Fabricate :user }
  let(:order) {Fabricate :order,user:lecturer}
    
  #creating one order that can be displayed 
  before(:each) do
    order
    page.windows[0].maximize
  end

  #after signing in as admin the user visits lecturers week to see orders of lecturers
  #one order in the actual week was fabricated (see before(:each)) 
  #as the actual week is preselected he can show this order by clicking "Anzeigen"
  #the user is supposed to see the actual order with the correct parameters(Experiment "Dummy Experiment")
  #and one comment ("Testkommentar")
  it "Dozentenwoche korrekt anzeigen als Admin" do
    sign_in admin
    visit "lecturer_week/new"
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(page.has_text?("Dummy Experiment")).to be_truthy
    expect(page.has_text?("Testkommentar")).to be_truthy
  end

  #after signing in as admin the user visits lecturers week to see orders of lecturers
  #one order in the actual week was fabricated (see before(:each)) 
  #as the actual week is preselected he can show this order by clicking "Anzeigen"
  #the user chooses to print the lecturers week
  #this test only checks if the correct system method(window.print()) is called when "drucken" gets clicked
  #testing if printing worked correctly has to be done manually
  #see test_cases.adoc TCxx 
  it "Dozentenwoche drucken als Admin" do
    sign_in admin
    visit "lecturer_week/new"
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(find_button("Drucken")[:onclick]). to eq("window.print();")       #check if "Drucken" button exist and the system printing menu gets called onclick
  end

  #after signing in as lecturer the user visits lecturers week to see his orders
  #one order in the actual week was fabricated (see before(:each)) 
  #as the actual week is preselected he can show this order by clicking "Anzeigen"
  #the user is supposed to see the actual order with the correct parameters(Experiment "Dummy Experiment")
  #and one comment ("Testkommentar")
  it "Dozentenwoche korrekt anzeigen als Dozent" do
    sign_in lecturer
    visit "lecturer_week/new"
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(page.has_text?("Dummy Experiment")).to be_truthy
    expect(page.has_text?("Testkommentar")).to be_truthy
  end

  #after signing in as lecturer the user visits lecturers week to see his orders
  #one order in the actual week was fabricated (see before(:each)) 
  #as the actual week is preselected he can show this order by clicking "Anzeigen"
  #the user chooses to print his lecturers week
  #this test only checks if the correct system method(window.print()) is called when "drucken" gets clicked
  #testing if printing worked correctly has to be done manually
  #see test_cases.adoc TCxx 
  it "Dozentenwoche drucken als Dozent" do
    sign_in lecturer
    visit "lecturer_week/new"
    find(:xpath,"//input[@value='Anzeigen']").click
    expect(find_button("Drucken")[:onclick]). to eq("window.print();")       #check if "Drucken" button exist and the system printing menu gets called onclick
  end
  
end