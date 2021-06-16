require "rails_helper"

describe "Lecturer Week Workflow" do
  let(:guest) { Fabricate :user, role: :guest }
  let(:lecturer) { Fabricate :user, role: :lecturer }

  it "should not allow guests" do
    sign_in guest
    get new_lecturer_week_path
    follow_redirect!
    expect(path).to eql(root_path)
  end

  context "as admin" do
    let(:admin) { Fabricate :user, role: :admin }

    before(:each) do
      sign_in admin
    end

    it "render new page" do
      get new_lecturer_week_path
      expect(response).to be_successful
      expect(response.body).to include("Dozentenwoche")
    end

    it "rerender form on errors" do
      get lecturer_week_path, params: { lecturer_week: { year: 1970, week: 1, lecturer_id: lecturer.id } }
      expect(response.body).to include("Dozentenwoche")
      expect(response.body).to include("muss größer oder gleich 2021 sein")

      get lecturer_week_path, params: { lecturer_week: { year: 2021, week: 72, lecturer_id: lecturer.id } }
      expect(response.body).to include("Dozentenwoche")
      expect(response.body).to include("muss kleiner oder gleich 52 sein")
    end

    it "show flash message if no order in specific period" do
      get lecturer_week_path, params: { lecturer_week: { year: 2021, week: 21, lecturer_id: lecturer.id } }
      expect(response).to be_successful
      expect(response.body).to include("Dozentenwoche")
      expect(response.body).to include("In dieser Woche wurden von dem Dozenten #{lecturer.name} keine Experimente gebucht!")
    end

    it "show lecturer week if there is an order" do
      Timecop.travel(2021, 5, 28) do
        order = Fabricate :order, user: lecturer
        get lecturer_week_path, params: { lecturer_week: { year: 2021, week: 21, lecturer_id: lecturer.id } }
        expect(response).to be_successful
        expect(response.body).to include(order.course.name)
        expect(response.body).to include("SS 2021")
        expect(response.body).to include(order.ordered_experiments.first.experiment.name)
        expect(response.body).to include(order.comment)
      end
    end
  end

  context "as lecturer" do
    before(:each) do
      sign_in lecturer
    end

    it "should not have lecturer selection on form" do
      get new_lecturer_week_path
      expect(response).to be_successful
      expect(response.body).to_not include("Dozenten-Auswahl")
    end

    it "disallowed to access lecturer week of other lecturer" do
      other_lecturer = Fabricate :user, role: :lecturer
      order =
        Timecop.travel(2021, 5, 28) do
          Fabricate :order, user: lecturer
        end

      get lecturer_week_path, params: { lecturer_week: { year: 2021, week: 21, lecturer_id: other_lecturer.id } }
      expect(response).to be_successful
      expect(response.body).to_not include(other_lecturer.name)
      expect(response.body).to include(order.course.name)
    end
  end
end
