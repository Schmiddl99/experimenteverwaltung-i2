require "rails_helper"

describe LecturerWeek do
  let(:password) { Faker::Config.random }
  let(:lecturer) { Fabricate :user, password: password, role: :lecturer }
  let(:course) { Fabricate :course }
  let(:experiment) { Fabricate :experiment }
  let(:next_week) { Date.current + 1.week }
  let(:valid_params) { { lecturer_id: lecturer.id, week: next_week.cweek, year: next_week.year } }
  let(:order) { Fabricate :order, user: lecturer, course_at_date: next_week }

  it "get all orders in date range" do
    other_order = Fabricate :order, course_at_date: Date.current + 2.weeks, user: lecturer
    order_start = Fabricate :order, course_at_date: next_week.beginning_of_week, course_at_time: '00:01', user: lecturer
    order_end = Fabricate :order, course_at_date: next_week.end_of_week, course_at_time: '23:59', user: lecturer
    order

    lecturer_week = LecturerWeek.new(valid_params)
    expect(lecturer_week).to be_valid
    expect(lecturer_week.orders.first).to eql(order_start)
    expect(lecturer_week.orders.second).to eql(order)
    expect(lecturer_week.orders.last).to eql(order_end)
    expect(lecturer_week.orders).to_not include(other_order)
  end

  it "dont get orders from other lecturers" do
    other_order = Fabricate :order
    lecturer_week = LecturerWeek.new(valid_params)
    expect(lecturer_week).to be_valid
    expect(lecturer_week.orders).to include(order)
    expect(lecturer_week.orders).to_not include(other_order)
  end

  it "validate year" do
    lecturer_week = LecturerWeek.new(valid_params.merge(year: 2020))
    expect(lecturer_week).to be_invalid
    expect(lecturer_week.errors.messages[:year].first).to eql("muss größer oder gleich 2021 sein")

    lecturer_week.year = Date.current.year + 1
    expect(lecturer_week).to be_invalid
    expect(lecturer_week.errors.messages[:year].first).to eql("muss kleiner oder gleich #{Date.current.year} sein")
  end

  it "validate week" do
    lecturer_week = LecturerWeek.new(valid_params.merge(year: 2021, week: 53))
    expect(lecturer_week).to be_invalid
    expect(lecturer_week.errors.messages[:week].first).to eql("muss kleiner oder gleich 52 sein")

    Timecop.travel(2027, 1, 1) do
      lecturer_week.assign_attributes(year: 2026 , week: 53)
      expect(lecturer_week).to be_valid


      lecturer_week.week = 54
      expect(lecturer_week).to be_invalid
      expect(lecturer_week.errors.messages[:week].first).to eql("muss kleiner oder gleich 53 sein")

      lecturer_week.week = 0
      expect(lecturer_week).to be_invalid
      expect(lecturer_week.errors.messages[:week].first).to eql("muss größer oder gleich 1 sein")
    end
  end

  it "validate lecturer" do
    guest = Fabricate :user, role: :guest
    lecturer_week = LecturerWeek.new(valid_params.merge(lecturer_id: guest.id))
    expect(lecturer_week).to be_invalid
    expect(lecturer_week.errors.messages[:lecturer].first).to eql("muss ausgefüllt werden")

    admin = Fabricate :user, role: :admin
    lecturer_week = LecturerWeek.new(valid_params.merge(lecturer_id: admin.id))
    expect(lecturer_week).to be_invalid
    expect(lecturer_week.errors.messages[:lecturer].first).to eql("muss ausgefüllt werden")

    lecturer_week = LecturerWeek.new(valid_params.merge(lecturer_id: nil))
    expect(lecturer_week).to be_invalid
    expect(lecturer_week.errors.messages[:lecturer].first).to eql("muss ausgefüllt werden")
  end

  it "ignore lecturer id if lecturer passed" do
    other_lecturer = Fabricate :user, role: :lecturer
    lecturer_week = LecturerWeek.new(valid_params.merge(user: other_lecturer))
    expect(lecturer_week.lecturer).to eql(other_lecturer)
  end
end
