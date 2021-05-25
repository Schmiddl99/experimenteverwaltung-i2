require "rails_helper"

describe Order do
  let(:course) { Fabricate :course }

  it "#set_course_at" do
    order = Order.new(course_at_date: Date.tomorrow, course_at_time: "12:00")
    order.valid?
    expect(order.course_at).to eql(Date.tomorrow.midday)

    order = Order.new(course_at_date: Date.tomorrow)
    order.valid?
    expect(order.course_at).to be_nil
  end

  it "validate course_at_date" do
    order = Order.new(course_at_date: Date.today)
    order.valid?
    expect(order.errors.messages.keys).to include(:course_at_date)

    order.course_at_date = Date.tomorrow
    order.valid?
    expect(order.errors.messages.keys).to_not include(:course_at_date)
  end

  it "validate course_at_time format" do
    order = Order.new(course_at_time: "abc")
    order.valid?
    expect(order.errors.messages.keys).to include(:course_at_time)

    order.course_at_time = "30:00"
    order.valid?
    expect(order.errors.messages.keys).to include(:course_at_time)

    order.course_at_time = "17:00"
    order.valid?
    expect(order.errors.messages.keys).to_not include(:course_at_time)
  end

  it "validate course needed" do
    order = Order.new
    order.valid?
    expect(order.errors.messages.keys).to include(:course)

    order.course = course
    order.valid?
    expect(order.errors.messages.keys).to_not include(:course)
  end

  it "validate ordered experiments size" do
    order = Order.new
    order.valid?
    expect(order.errors.messages.keys).to include(:ordered_experiments)

    order.ordered_experiments.build
    order.valid?
    expect(order.errors.messages.keys).to_not include(:ordered_experiments)
  end
end
