require "rails_helper"

describe "Checkout Workflow" do
  let(:password) { Faker::Config.random }
  let(:admin) { Fabricate :user, password: password, role: :admin }
  let(:guest) { Fabricate :user, password: password, role: :guest }
  let(:lecturer) { Fabricate :user, password: password, role: :lecturer }
  let(:course) { Fabricate :course }
  let(:experiment) { Fabricate :experiment }
  let(:order) { Order.new(course: course, course_at: Date.tomorrow, user: lecturer) }
  let(:valid_order_params) {
    {
      course_id: course.id,
      alternative_course_name: "Alternativer Titel",
      course_at_date: I18n.l(Date.tomorrow),
      course_at_time: '12:00'
    }
  }

  before(:each) do
    sign_in lecturer
  end

  it "redirect if no order started" do
    get(checkout_path)
    follow_redirect!
    expect(path).to eql(root_path)
  end

  describe "new" do
    it "should disallow guests" do
      sign_in guest
      get new_checkout_path
      expect(response).to be_redirect
      follow_redirect!
      expect(response.body).to include("Benötigte Rechte nicht vorhanden.")
    end

    it "should disallow admins" do
      sign_in admin
      get new_checkout_path
      expect(response).to be_redirect
      follow_redirect!
      expect(response.body).to include("Benötigte Rechte nicht vorhanden.")
    end

    it "render pre-settings page" do
      get new_checkout_path
      expect(response).to be_successful
      expect(response.body).to include("Voreinstellungen")
      expect(response.body).to_not include("Buchung starten")
    end
  end

  describe "create" do
    it "init order in session" do
      post(checkout_path, params: { order: valid_order_params })

      follow_redirect!
      expect(response.body).to include("Buchung erfolgreich gestartet!")
      expect(response.body).to include("zum Buchungsabschluss")
      order = session[:order]
      expect(order).to_not be_nil
      expect(order.course_at).to eql(Date.tomorrow.midday)
      expect(order.user).to eql(lecturer)
      expect(order.alternative_course_name).to eql("Alternativer Titel")
    end

    it "rerender form with errors if not valid" do
      post(checkout_path, params: { order: { course_id: "", course_at_date: "", course_at_time: "" } })
      expect(response).to be_successful
      expect(response.body).to include("Buchung konnte nicht gestartet werden! Bitte korrigieren Sie Ihre Angaben.")
      expect(response.body).to include("Voreinstellungen")
      expect(response.body).to include("ist kein Datum")
      expect(response.body).to include("ist nicht gültig")
      expect(session[:order]).to be_nil
    end
  end

  describe "add_experiment" do
    it "add persisted experiment" do
      post(checkout_path, params: { order: valid_order_params })

      patch(add_experiment_checkout_path, params: { experiment_id: experiment.id })
      follow_redirect!
      expect(path).to eql(root_path)
      expect(session[:order].ordered_experiments.size).to eql(1)

      ordered_experiment = session[:order].ordered_experiments.first
      expect(ordered_experiment.sort).to eql(1)
      expect(ordered_experiment.experiment).to eql(experiment)
      expect(response.body).to include("Experiment erfolgreich zur Buchung hinzugefügt!")
    end

    it "add new dummy experiment" do
      post(checkout_path, params: { order: valid_order_params })

      patch(add_experiment_checkout_path, params: { dummy_experiment: { name: "Dummy Experiment" } })
      follow_redirect!
      expect(path).to eql(root_path)
      expect(session[:order].ordered_experiments.size).to eql(1)

      ordered_experiment = session[:order].ordered_experiments.first
      expect(ordered_experiment.sort).to eql(1)
      dummy_experiment = ordered_experiment.experiment
      expect(dummy_experiment).to_not be_persisted
      expect(dummy_experiment.name).to eql("Dummy Experiment")
      expect(response.body).to include("Benutzerdefiniertes Experiment erfolgreich zur Buchung hinzugefügt!")
    end

    it "display error if dummy experiment not valid" do
      post(checkout_path, params: { order: valid_order_params })

      patch(add_experiment_checkout_path, params: { dummy_experiment: { name: "" } })
      follow_redirect!
      expect(path).to eql(root_path)
      expect(session[:order].ordered_experiments.size).to eql(0)
      expect(response.body).to include("Benutzerdefiniertes Experiment konnte nicht gespeichert werden!")
    end
  end

  describe "remove_experiment" do
    it "remove peristed experiment" do
      post(checkout_path, params: { order: valid_order_params })
      patch(add_experiment_checkout_path, params: { experiment_id: experiment.id })

      order = session[:order]
      expect(order.ordered_experiments.size).to eql(1)

      delete(remove_experiment_checkout_path, params: { experiment_sort: order.ordered_experiments.first.sort })
      follow_redirect!
      expect(path).to eql(root_path)
      order = session[:order]
      expect(order.ordered_experiments.size).to eql(0)
      expect(response.body).to include("Experiment erfolgreich aus der Buchung entfernt!")
    end

    it "remove dummy experiment" do
      post(checkout_path, params: { order: valid_order_params })
      patch(add_experiment_checkout_path, params: { dummy_experiment: { name: "Dummy Experiment" } })

      order = session[:order]
      expect(order.ordered_experiments.size).to eql(1)

      delete(remove_experiment_checkout_path, params: { experiment_sort: order.ordered_experiments.first.sort })
      follow_redirect!
      expect(path).to eql(root_path)
      order = session[:order]
      expect(order.ordered_experiments.size).to eql(0)
      expect(response.body).to include("Experiment erfolgreich aus der Buchung entfernt!")
    end
  end

  describe "destroy" do
    it "destroy unfinished order" do
      post(checkout_path, params: { order: valid_order_params })
      expect(session[:order]).to_not be_nil

      delete(checkout_path)
      follow_redirect!

      expect(path).to eql(root_path)
      expect(session[:order]).to be_nil
      expect(response.body).to include("Buchung erfolgreich abgebrochen!")
    end
  end

  describe "show" do
    it "render order" do
      post(checkout_path, params: { order: valid_order_params })
      expect(session[:order]).to_not be_nil

      get(checkout_path)
      expect(response).to be_successful
      expect(response.body).to include("Warenkorb")
      expect(response.body).to_not include("zum Buchungsabschluss")
    end
  end

  describe "update" do
    it "update order of experiments" do
      post(checkout_path, params: { order: valid_order_params })
      patch(add_experiment_checkout_path, params: { dummy_experiment: { name: "Dummy Experiment" } })
      patch(add_experiment_checkout_path, params: { experiment_id: experiment.id })

      order = session[:order]
      ordered_experiments = order.ordered_experiments.sort_by(&:sort)
      expect(ordered_experiments.size).to eql(2)
      expect(ordered_experiments.first.experiment.name).to eql("Dummy Experiment")
      expect(ordered_experiments.second.experiment).to eql(experiment)

      patch(
        checkout_path,
        params: {
          order: {
            ordered_experiments_attributes: {
              "0" => { sort: 2 },
              "1" => { sort: 1 }
            }
          }
        }
      )

      order = session[:order]
      expect(order).to_not be_persisted
      ordered_experiments = order.ordered_experiments.sort_by(&:sort)
      expect(ordered_experiments.size).to eql(2)
      expect(ordered_experiments.first.experiment).to eql(experiment)
      expect(ordered_experiments.second.experiment.name).to eql("Dummy Experiment")

      follow_redirect!
      expect(response.body).to include("Änderungen erfolgreich gespeichert!")
    end

    it "add comment" do
      post(checkout_path, params: { order: valid_order_params })
      patch(add_experiment_checkout_path, params: { experiment_id: experiment.id })

      patch(checkout_path, params: { order: { comment: "Toller Kommentar" } })
      order = session[:order]
      expect(order.comment).to eql("Toller Kommentar")

      follow_redirect!
      expect(response.body).to include("Änderungen erfolgreich gespeichert!")
    end
  end

  describe "persist" do
    it "saves order" do
      post(checkout_path, params: { order: valid_order_params })
      patch(add_experiment_checkout_path, params: { dummy_experiment: { name: "Dummy Experiment" } })
      patch(add_experiment_checkout_path, params: { experiment_id: experiment.id })

      expect do
        patch(
          checkout_path,
          params: {
            order: {
              ordered_experiments_attributes: {
                "0" => { sort: 2 },
                "1" => { sort: 1 }
              },
              comment: "Toller Kommentar"
            },
            persist: "1"
          }
        )
      end.to change { Order.count }

      expect(session[:order]).to be_nil

      order = Order.last
      expect(order.comment).to eql("Toller Kommentar")
      expect(order.course_at).to eql(Date.tomorrow.midday)
      expect(order.course).to eql(course)
      expect(order.alternative_course_name).to eql("Alternativer Titel")

      ordered_experiments = order.ordered_experiments.order(:sort)
      expect(ordered_experiments.size).to eql(2)
      expect(ordered_experiments.first.experiment).to eql(experiment)
      expect(ordered_experiments.second.experiment.name).to eql("Dummy Experiment")

      expect(response).to be_successful
      expect(response.body).to include("Ihre Buchung wurde gespeichert!")
      expect(response.body).to include("Sie finden eine Übersicht Ihrer Buchungen im Journal.")
    end

    it "fail if no experiments attached" do
      post(checkout_path, params: { order: valid_order_params })
      expect do
        patch(
          checkout_path,
          params: {
            order: {
              comment: "Toller Kommentar"
            },
            persist: "1"
          }
        )
      end.to_not change { Order.count }

      expect(session[:order]).to_not be_nil
      order = session[:order]
      expect(order.comment).to eql("Toller Kommentar")

      expect(response.body).to include("Warenkorb")
      expect(response.body).to include("Fehler beim Speichern der Buchung! Bitte versuchen Sie es erneut.")
    end
  end
end
