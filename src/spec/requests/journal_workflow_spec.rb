require "rails_helper"

describe "Journal Workflow" do
  let(:lecturer) { Fabricate :user, role: :lecturer }
  let(:order) { Fabricate :order, user: lecturer }

  before(:each) do
    sign_in lecturer
  end

  describe "index" do
    it "get only orders of lecturer" do
      other_lecturer = Fabricate :user, role: :lecturer
      other_order = Fabricate :order, user: other_lecturer
      order

      get orders_path
      expect(response).to be_successful
      expect(response.body).to include(order.course.name)
      expect(response.body).to_not include(other_order.course.name)
    end

    it "get paged results" do
      10.times do |n|
        Fabricate :order, user: lecturer, course_at: n.days.from_now
      end

      order_on_next_page = Fabricate :order, user: lecturer, course_at: 1.year.ago
      get orders_path
      expect(response.body).to_not include(order_on_next_page.course.name)
      get orders_path(page: 2)
      expect(response.body).to include(order_on_next_page.course.name)
    end
  end

  describe "edit" do
    it "set chosen order in session" do
      get edit_order_path(order)
      expect(response).to be_redirect
      follow_redirect!
      expect(response.body).to include("Warenkorb")
    end

    it "cannot edit orders from past" do
      order.update_column(:course_at, Date.yesterday)
      get edit_order_path(order)
      expect(response).to be_redirect
      follow_redirect!
      expect(response.body).to include("Sie können nur Buchungen in der Zukunft bearbeiten!")
    end
  end

  describe "destroy" do
    it "destroy order" do
      delete order_path(order)
      expect(response).to be_redirect
      expect { order.reload }.to raise_exception(ActiveRecord::RecordNotFound)

      follow_redirect!
      expect(response.body).to include "Die Buchung wurde erfolgreich gelöscht!"
    end

    it "clear session if in any checkout process" do
      get edit_order_path(order)
      expect(session[:order]).to eql(order)
      delete order_path(order)
      expect(session[:order]).to be_nil
    end

    it "cannot destroy order from past" do
      order.update_column(:course_at, Date.yesterday)
      delete order_path(order)
      expect(response).to be_redirect
      follow_redirect!
      expect(response.body).to include("Sie können nur Buchungen in der Zukunft bearbeiten!")
    end
  end

end
