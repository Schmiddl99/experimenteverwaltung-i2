# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: "Entwickler", username: "dev", password: "123456", role: :admin)
User.create(name: "Matthias Heisig", username: "m.heisig", password: "123456", role: :admin)

a = Category.create(name: "Atom und Festkörperphysik", label: "A")
e = Category.create(name: "Elektrizität und Magentismus", label: "E")
m = Category.create(name: "Mechanik", label: "M")
o = Category.create(name: "Optik", label: "O")
s = Category.create(name: "Schwingung und Wellen", label: "S")
w = Category.create(name: "Wärmelehre", label: "W")

SubCategory.create(name: "Einführung", label: "A-01", category: a)

SubCategory.create(name: "Elektrischer Strom", label: "E-01", category: e)
SubCategory.create(name: "Strom - Ladung - Spannung", label: "E-02", category: e)
SubCategory.create(name: "Elektrostatik", label: "E-03", category: e)
SubCategory.create(name: "Elektrisches Feld im leeren Raum", label: "E-04", category: e)
SubCategory.create(name: "Magnetisches Feld im leeren Raum", label: "E-05", category: e)
SubCategory.create(name: "Induktionsgesetz", label: "E-06", category: e)
SubCategory.create(name: "Wechselstrom", label: "E-07", category: e)
SubCategory.create(name: "Schnell veränderliche Felder", label: "E-08", category: e)
SubCategory.create(name: "Elektrischer Strom in Flüssigkeiten", label: "E-09", category: e)
SubCategory.create(name: "Elektrischer Strom in Gasen", label: "E-10", category: e)
SubCategory.create(name: "Elektrischer Strom in festen Körpern", label: "E-11", category: e)
SubCategory.create(name: "Nichtleiter im elektrischen Feld", label: "E-12", category: e)
SubCategory.create(name: "Magnetische Eigenschaften der Stoffe", label: "E-13", category: e)
SubCategory.create(name: "Elektromagnetische Schwingungen und Wellen", label: "E-14", category: e)

SubCategory.create(name: "Einleitung", label: "M-01", category: m)
SubCategory.create(name: "Kinematik", label: "M-02", category: m)
SubCategory.create(name: "Dynamik der Punktmasse", label: "M-03", category: m)
SubCategory.create(name: "Energie", label: "M-04", category: m)
SubCategory.create(name: "Syteme von Punktmassen", label: "M-05", category: m)
SubCategory.create(name: "Statik starre Körper", label: "M-06", category: m)
SubCategory.create(name: "Dynamik starrer Körper", label: "M-07", category: m)
SubCategory.create(name: "Bewegung im beschleunigten Bezugssystem", label: "M-08", category: m)
SubCategory.create(name: "Eigentschaften fester Körper", label: "M-09", category: m)
SubCategory.create(name: "Ruhende Flüssigkeiten und Gase", label: "M-10", category: m)
SubCategory.create(name: "Strömende Flüssigkeiten und Gase", label: "M-11", category: m)

SubCategory.create(name: "Fotometrie - und Farblehre", label: "O-01", category: o)
SubCategory.create(name: "Lichtquellen", label: "O-02", category: o)
SubCategory.create(name: "Geometrische Optik", label: "O-03", category: o)
SubCategory.create(name: "Wellenoptik", label: "O-04", category: o)

SubCategory.create(name: "Mechanische Schwingungen", label: "S-01", category: s)
SubCategory.create(name: "Mechanische Wellen", label: "S-02", category: s)

SubCategory.create(name: "Temperatur", label: "W-01", category: w)
SubCategory.create(name: "Zuständsänderung der Stoffe", label: "W-02", category: w)
SubCategory.create(name: "Erster Hauptsatz der Wärmelehre", label: "W-03", category: w)
SubCategory.create(name: "Zweiter Hautpsatz der Wärmelehre", label: "W-04", category: w)
SubCategory.create(name: "Atomtheorie der Wärmelehre", label: "W-05", category: w)

Equipment.create(name: "Flammenrohr mit Lautsprecher", location: "auf S 1", inventory_nr: "0")
Equipment.create(name: "Propangas", location: "B 2", inventory_nr: "1")
Equipment.create(name: "Verstärker Leybold", location: "V 13", inventory_nr: "2")
Equipment.create(name: "TFG 470 Hz", location: "V 10", inventory_nr: "3")
Equipment.create(name: "Wärmestrahlungsgerät kompl.", location: "W1", inventory_nr: "4")
Equipment.create(name: "Strahler", location: "W1", inventory_nr: "5")
Equipment.create(name: "Wärmebildkamera", location: "N 227", inventory_nr: "6")
Equipment.create(name: "Trafo für Halle-Magnet", location: "V33", inventory_nr: "7")

if ENV['USER'] == "witt"
  path = "/home/witt/DB_Gefahren/"
  Danger.create(name: "Explosive Stoffe/Gemische und Erzeugnisse mit Explosivstoff", label: "GHS01", file: File.open("#{path}GHS01.png"))
  Danger.create(name: "Entzündbare Stoffe", label: "GHS02", file: File.open("#{path}GHS02.png"))
  Danger.create(name: "Oxidierende Stoffe", label: "GHS03", file: File.open("#{path}GHS03.png"))
  Danger.create(name: "Gase unter Druck", label: "GHS04", file: File.open("#{path}GHS04.png"))
  Danger.create(name: "Stoffe mit Ätzwirkung", label: "GHS05", file: File.open("#{path}GHS05.png"))
  Danger.create(name: "Giftige Stoffe", label: "GHS06", file: File.open("#{path}GHS06.png"))
  Danger.create(name: "Gesundheitsschädliche und reizende Stoffe", label: "GHS07", file: File.open("#{path}GHS07.png"))
  Danger.create(name: "Gefahr für die Gesundheit", label: "GHS08", file: File.open("#{path}GHS08.png"))
  Danger.create(name: "Umweltgefährdende Stoffe", label: "GHS09", file: File.open("#{path}GHS09.png"))
end
