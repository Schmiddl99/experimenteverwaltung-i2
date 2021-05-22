Fabricator :user do
  name { Faker::Name.name }
  username { Faker::Internet.email }
  password { Faker::Config.random }
  role :admin
  active true
end

Fabricator :category do
  name 'TestCategory'
  label 'TestLabel'
end

Fabricator :sub_category do
  name 'TestSubCategory'
  label 'TestLabel'
  category { Fabricate :category }
end

Fabricator :experiment do
  name 'TestExperiment'
  label 'TestLabel.02'
  deleted false
  sub_category { Fabricate :sub_category }
  description 'TestDescription'
  user { Fabricate :user }
end

Fabricator :link do
  url 'https://www.google.de'
  experiment { Fabricate :experiment }
end

Fabricator :equipment do
  name 'TestEquipment'
  location 'TestLocation'
  inventory_nr 'TestNr'
end

Fabricator :experiment_equipment_assignment do
  experiment { Fabricate :experiment }
  equipment { Fabricate :equipment }
end

Fabricator :medium do
  name 'TestMedium'
  file { File.open('spec/fixtures/file1.jpg') }
  experiment { Fabricate :experiment }
end

Fabricator :document do
  name 'TestDocument'
  experiment { Fabricate :experiment }
  file { File.open('spec/fixtures/file.pdf') }
end

Fabricator :danger do
  name 'TestGefahr'
  label 'TestLabel'
  file { File.open('spec/fixtures/file1.jpg') }
end

Fabricator :experiment_danger_assignment do
  experiment { Fabricate :experiment }
  danger { Fabricate :danger }
end

Fabricator :course do
  name { "Teststudiengang" }
end
