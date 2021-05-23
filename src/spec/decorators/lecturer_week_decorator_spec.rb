require "rails_helper"

describe LecturerWeekDecorator do
  let(:password) { Faker::Config.random }
  let(:lecturer) { Fabricate :user, password: password, role: :lecturer }
  let(:next_week) { Date.current + 1.week }
  let(:valid_params) { { lecturer_id: lecturer.id, week: next_week.cweek, year: next_week.year } }
  let(:lecturer_week) { LecturerWeek.new(valid_params).decorate }

  it "return correct heading" do
    lecturer_week.year = 2021
    Timecop.travel(2022, 1, 1) do
      lecturer_week.week = 1
      expect(lecturer_week.heading).to eql("KW 1. | 04.01.2021 - 10.01.2021 | WS 20/21")

      lecturer_week.week = 25
      lecturer_week.date_range = nil
      expect(lecturer_week.heading).to eql("KW 25. | 21.06.2021 - 27.06.2021 | SS 2021")

      lecturer_week.week = 52
      lecturer_week.date_range = nil
      expect(lecturer_week.heading).to eql("KW 52. | 27.12.2021 - 02.01.2022 | WS 21/22")
    end
  end

  it "return all comments" do
    lecturer_week.year = 2021
    lecturer_week.week = 21

    orders = []
    Timecop.travel(2021, 1, 1) do
      4.times do |n|
        orders[n] = Fabricate :order, course_at_date: Date.commercial(2021, 21, n + 1), user: lecturer, comment: "Kommentar #{n + 1}"
      end
      orders[4] = Fabricate :order, course_at_date: Date.commercial(2021, 21, 5), user: lecturer, alternative_course_name: "Anderer Kursname", comment: "Kommentar 5"
    end

    comment = [
      "für Montag #{orders.first.course.name}, Kommentar 1",
      "für Dienstag #{orders.second.course.name}, Kommentar 2",
      "für Mittwoch #{orders.third.course.name}, Kommentar 3",
      "für Donnerstag #{orders.fourth.course.name}, Kommentar 4",
      "für Freitag #{orders.last.course.name} (Anderer Kursname), Kommentar 5"
    ].join(", ")

    expect(lecturer_week.comment).to eql(comment)
  end

  it "return correct course at header for an order" do
    Timecop.travel(2021, 5, 28) do
      order = Fabricate :order, user: lecturer, course_at_date: Date.new(2021, 5, 29), course_at_time: '9:00'
      expect(lecturer_week.course_at_header(order)).to eql("Sa 9:00 Uhr | 29.5.2021")
    end
  end

end
