# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.find_or_create_by!([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.find_or_create_by!(name: 'Luke', movie: movies.first)
User.create_with(password: "123456").find_or_create_by!(name: "Entwickler", username: "dev", role: :admin)
User.create_with(password: "123456").find_or_create_by!(name: "Matthias Heisig", username: "m.heisig", role: :admin)
User.create_with(password: "123456").find_or_create_by!(name: "Dozent", username: "lecturer", role: :lecturer)

a = Category.find_or_create_by!(name: "Atom und Festkörperphysik", label: "A")
e = Category.find_or_create_by!(name: "Elektrizität und Magentismus", label: "E")
m = Category.find_or_create_by!(name: "Mechanik", label: "M")
o = Category.find_or_create_by!(name: "Optik", label: "O")
s = Category.find_or_create_by!(name: "Schwingung und Wellen", label: "S")
w = Category.find_or_create_by!(name: "Wärmelehre", label: "W")

SubCategory.find_or_create_by!(name: "Einführung", label: "A-01", category: a)

SubCategory.find_or_create_by!(name: "Elektrischer Strom", label: "E-01", category: e)
SubCategory.find_or_create_by!(name: "Strom - Ladung - Spannung", label: "E-02", category: e)
SubCategory.find_or_create_by!(name: "Elektrostatik", label: "E-03", category: e)
SubCategory.find_or_create_by!(name: "Elektrisches Feld im leeren Raum", label: "E-04", category: e)
SubCategory.find_or_create_by!(name: "Magnetisches Feld im leeren Raum", label: "E-05", category: e)
SubCategory.find_or_create_by!(name: "Induktionsgesetz", label: "E-06", category: e)
SubCategory.find_or_create_by!(name: "Wechselstrom", label: "E-07", category: e)
SubCategory.find_or_create_by!(name: "Schnell veränderliche Felder", label: "E-08", category: e)
SubCategory.find_or_create_by!(name: "Elektrischer Strom in Flüssigkeiten", label: "E-09", category: e)
SubCategory.find_or_create_by!(name: "Elektrischer Strom in Gasen", label: "E-10", category: e)
SubCategory.find_or_create_by!(name: "Elektrischer Strom in festen Körpern", label: "E-11", category: e)
SubCategory.find_or_create_by!(name: "Nichtleiter im elektrischen Feld", label: "E-12", category: e)
SubCategory.find_or_create_by!(name: "Magnetische Eigenschaften der Stoffe", label: "E-13", category: e)
SubCategory.find_or_create_by!(name: "Elektromagnetische Schwingungen und Wellen", label: "E-14", category: e)

SubCategory.find_or_create_by!(name: "Einleitung", label: "M-01", category: m)
SubCategory.find_or_create_by!(name: "Kinematik", label: "M-02", category: m)
SubCategory.find_or_create_by!(name: "Dynamik der Punktmasse", label: "M-03", category: m)
SubCategory.find_or_create_by!(name: "Energie", label: "M-04", category: m)
SubCategory.find_or_create_by!(name: "Syteme von Punktmassen", label: "M-05", category: m)
SubCategory.find_or_create_by!(name: "Statik starre Körper", label: "M-06", category: m)
SubCategory.find_or_create_by!(name: "Dynamik starrer Körper", label: "M-07", category: m)
SubCategory.find_or_create_by!(name: "Bewegung im beschleunigten Bezugssystem", label: "M-08", category: m)
SubCategory.find_or_create_by!(name: "Eigentschaften fester Körper", label: "M-09", category: m)
SubCategory.find_or_create_by!(name: "Ruhende Flüssigkeiten und Gase", label: "M-10", category: m)
SubCategory.find_or_create_by!(name: "Strömende Flüssigkeiten und Gase", label: "M-11", category: m)

SubCategory.find_or_create_by!(name: "Fotometrie - und Farblehre", label: "O-01", category: o)
SubCategory.find_or_create_by!(name: "Lichtquellen", label: "O-02", category: o)
SubCategory.find_or_create_by!(name: "Geometrische Optik", label: "O-03", category: o)
SubCategory.find_or_create_by!(name: "Wellenoptik", label: "O-04", category: o)

SubCategory.find_or_create_by!(name: "Mechanische Schwingungen", label: "S-01", category: s)
SubCategory.find_or_create_by!(name: "Mechanische Wellen", label: "S-02", category: s)

SubCategory.find_or_create_by!(name: "Temperatur", label: "W-01", category: w)
SubCategory.find_or_create_by!(name: "Zuständsänderung der Stoffe", label: "W-02", category: w)
SubCategory.find_or_create_by!(name: "Erster Hauptsatz der Wärmelehre", label: "W-03", category: w)
SubCategory.find_or_create_by!(name: "Zweiter Hautpsatz der Wärmelehre", label: "W-04", category: w)
SubCategory.find_or_create_by!(name: "Atomtheorie der Wärmelehre", label: "W-05", category: w)

Equipment.find_or_create_by!(name: "Flammenrohr mit Lautsprecher", location: "auf S 1", inventory_nr: "0")
Equipment.find_or_create_by!(name: "Propangas", location: "B 2", inventory_nr: "1")
Equipment.find_or_create_by!(name: "Verstärker Leybold", location: "V 13", inventory_nr: "2")
Equipment.find_or_create_by!(name: "TFG 470 Hz", location: "V 10", inventory_nr: "3")
Equipment.find_or_create_by!(name: "Wärmestrahlungsgerät kompl.", location: "W1", inventory_nr: "4")
Equipment.find_or_create_by!(name: "Strahler", location: "W1", inventory_nr: "5")
Equipment.find_or_create_by!(name: "Wärmebildkamera", location: "N 227", inventory_nr: "6")
Equipment.find_or_create_by!(name: "Trafo für Halle-Magnet", location: "V33", inventory_nr: "7")

Course.find_or_create_by!(name: 'Maschinenbau')
Course.find_or_create_by!(name: 'Elektrotechnik')
Course.find_or_create_by!(name: 'Chemie')
Course.find_or_create_by!(name: 'Wirtschaftsingenieure')
Course.find_or_create_by!(name: 'Bauingenieure')
Course.find_or_create_by!(name: 'Sonstiges')

if ENV['USER'] == "witt"
  path = "/home/witt/DB_Gefahren/"
  Danger.find_or_create_by!(name: "Explosive Stoffe/Gemische und Erzeugnisse mit Explosivstoff", label: "GHS01", file: File.open("#{path}GHS01.png"))
  Danger.find_or_create_by!(name: "Entzündbare Stoffe", label: "GHS02", file: File.open("#{path}GHS02.png"))
  Danger.find_or_create_by!(name: "Oxidierende Stoffe", label: "GHS03", file: File.open("#{path}GHS03.png"))
  Danger.find_or_create_by!(name: "Gase unter Druck", label: "GHS04", file: File.open("#{path}GHS04.png"))
  Danger.find_or_create_by!(name: "Stoffe mit Ätzwirkung", label: "GHS05", file: File.open("#{path}GHS05.png"))
  Danger.find_or_create_by!(name: "Giftige Stoffe", label: "GHS06", file: File.open("#{path}GHS06.png"))
  Danger.find_or_create_by!(name: "Gesundheitsschädliche und reizende Stoffe", label: "GHS07", file: File.open("#{path}GHS07.png"))
  Danger.find_or_create_by!(name: "Gefahr für die Gesundheit", label: "GHS08", file: File.open("#{path}GHS08.png"))
  Danger.find_or_create_by!(name: "Umweltgefährdende Stoffe", label: "GHS09", file: File.open("#{path}GHS09.png"))
end
