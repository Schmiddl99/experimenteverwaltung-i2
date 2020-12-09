# EMS - Experiment-Management-System 

## Installation

### Git Repo auschecken

```
git clone git@gitlab.com:se-ii/rails-projekt.git
```

Eventuell müsst ihr hierfür git installieren:

```
sudo apt install git
```
für Debian Systeme

Und auf gitlab.com euren SSH Key hinterlegen: 
https://gitlab.com/profile/keys

### Ruby

Hier müsst auf einer UNIX Maschine (Debian, Ubuntu, Mac oder andere) RVM (Ruby Version Manager)

```
curl -sSL https://get.rvm.io | bash
```

Anschließend könnt ihr in dem Repo folgendes ausführen um alle Gems (Erweiterungen) zu installieren.

```
bundle install
```
 
Um Inital eine Datenbank einzurichten:

```
rabe db:create
```

## Quick Start

### Git

Es wäre sehr hilfreich wenn ihr auf einen anderen Branch eure Funktionen entwickelt. Das heißt das ihr auf einen andern Strang zum Master entwickelt. Hier könnt euch einen neuen Branch so anlegen:

```
git checkout -b vincent/categorien
```

Vieleicht können wir uns drauf einigen dies Nameing zu benutzen also Name/Funktionsname einigen. 

Um Dateien zu commiten müsst ihr die entsprechen Dateien selektieren:

```
git add app/controllers/category_controller.rb
```

oder einfach alle Änderungen mit :D 

```
git add .
```

Danach müsst ihr noch eine Commit Nachricht vergeben:

```
git commit -m "Kategorien zum Experiment hinzugefügt"
```

Danach bitte euren Branch pushen:

```
git push origin vincent/categorien
```

Wenn ihr dies das ersten mal macht müsst ihr über den Link der euch angezeigt wird einen Merge-Request anlegen. Wenn ihr eine Funktionen fertig habt können wir uns die Änderungen des Branches ansehen und Feedback geben. Anschießend wird dieses gemergt und kommt auf den Master Strang und geht so live.

### Interfaces anlegen

Um für euer Funktionen ein "Grund"-Interface anzulegen könnt ihr gern Scaffolds dazu nutzen:

```
rails generate scaffold Experiment title category:belongs_to nummer:integer  .....
```

Anschießend kann die erstellte Migration die die Tabelle category anlegt ausgeführt werden

```
  rake db:migrate
```

Es gibt hier folgende Datentypen:

|           Datentyp           |       Beispiel       |
|------------------------------|----------------------|
| :integer                     | 1                    | 
| :float                       | 1.5                  | 
| :decimal                     | "9.99"               | 
| :datetime, :timestamp, :time | Time.now.to_s(:db)   | 
| :date                        | Date.today.to_s(:db) | 
| :string                      | "MyString"           | 
| :text                        | "MyText"             | 
| :boolean                     | false                | 
| :references, :belongs_to     | Category             | 

Damit wir eine Deutsche Übersetzung unsere englisch benannten Tabellen und Attribute haben können wir dies in folgenden Dateien vornehmen:

### Übersetzung

`config/local/de.yml` um die Tabellen zu benennen:
```yml
de:
  activerecord:
    models:
      category: "Kategorie"
```

Die Attribute einer Tabelle wird in der Datei `config/local/simple_form.de.yml`
```yml
de:
  simple_form:
    "yes": 'Ja'
    "no": 'Nein'
    required:
      text: 'Pflichtfeld'
      mark: '*'
    error_notification:
      default_message: "Bitte überprüfen Sie die folgende Felder:"
    hints:
      category:
        name: "Hinweis zum Namen"    
    labels: &labels
      category:
        name: "Name"
      defaults:
    placeholders:
      <<: *labels%
```

***Auch wenn keine Übersetzung nötig ist, wäre es gut das ihr das hier definiert damit die Formulare gut aussehen. Hints können weggelassen werden.***

### Views

Es werden dann folgende Dateien und routen angelegt:

| Name                   | HTTP MODE | Path                      | SLIM (HTML) Dateien                   |
|------------------------|-----------|---------------------------|---------------------------------------|
| Übersicht              | GET       | /categories               | app/views/categories/index.html.slim  |
| Formular (anlegen)     | GET       | /categories/new           | app/views/categories/new.html.slim    |
| Anzeige                | GET       | /categories/:id           | app/views/categories/show.html.slim   |
| Formular (bearbeiten)  | GET       | /categories/:id/edit      | app/views/categories/edit.html.slim   |
| Anlegen                | POST      | /categories/              |                                       |
| Bearbeiten             | PUT       | /categories/:id           |                                       |
| Löschen                | DELETE    | /categories/:id           |                                       |


***Wenn ihr also an der View des Interfaces etwas verändern möchtet. Müsstet ihr in die entsprechende Datei und das entsprechend umbauen. Als Fontend Framework benutzen wir Bootstrap (https://getbootstrap.com) es wäre daher schön wenn ihr euch beim Views bauen daran halten könnt.***

### Actions

Sollten wir eine neue Action benötigen muss diese in dem Controller unter `app/controllers/categories_controller.rb` angelegt werden. Diese kann wie folgt aussehen

```ruby
def toggle
  @category.active = !@category.active
  @category.save
  redirect_to categories_path, note: "Kategorie wurde geändert"
end
```

In der `config/route.rb` eine neue Route angelegt werden.

```ruby
get "categories/:id/toggle", to: "categories#toggle", as: :category_toggle_path
```

### Validierung

In Rails wird eine Validierung nicht über die Datenbank geregelt die Validierung werden im Model definiert. Um zum Beispiel bei einen Namen nicht mehr als 30 Zeichen zu zulassen muss das Model unter `app/models/category.rb` angepasst werden:


```ruby
class Category < ApplicationRecord
  validates :name, length: { maximum: 32 }
end
```

**BTW: Rails kümmert sich im die Speicher Reservierung selber also macht es eigentlich nicht viel Sinn einen Namen zu begrenzten.**


***Eine Liste aller Vilidatoren findet ihr hier: https://guides.rubyonrails.org/active_record_validations.html#validation-helpers***

