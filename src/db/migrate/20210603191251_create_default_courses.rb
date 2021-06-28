class CreateDefaultCourses < ActiveRecord::Migration[6.1]
  NAMES = ['ALLGEMEINER MASCHINENBAU', 'ELEKTROTECHNIK', 'CHEMIEINGENIEURWESEN', 'UMWELTMONITORING', 'AGRARWIRTSCHAFT und GARTENBAU', 'WIRTSCHAFTSINGENIEURWESEN', 'BAUINGENIEURWESEN', 'GEOMATIK', 'Sonstiges']

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
