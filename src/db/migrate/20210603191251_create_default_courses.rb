class CreateDefaultCourses < ActiveRecord::Migration[6.1]
  NAMES = ['Maschinenbau', 'Elektrotechnik', 'Chemie', 'Wirtschaftsingenieure', 'Bauingenieure', 'Sonstiges']

  def up
    NAMES.each do |name|
      Course.find_or_create_by(name: name)
    end
  end

  def down
    NAMES.each do |name|
      Course.find_by(name: name)&.destroy
    end
  end
end
