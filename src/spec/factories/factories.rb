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
  sort 0
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
  name { Faker::Name.name }
end

Fabricator :order do
  user { Fabricate :user, role: :lecturer }
  comment { "Testkommentar" }
  course_at_date { Date.current + 1.day }
  course_at_time { "12:00" }
  course
  ordered_experiments(count: 1)

  before_validation do |order|
    order.ordered_experiments.each do |ordered_experiment|
      ordered_experiment.order = order
    end
  end
end

Fabricator :ordered_experiment do
  sort { 1 }
  experiment { Fabricate :dummy_experiment }
end

Fabricator :dummy_experiment do
  name { "Dummy Experiment Name" }
end
