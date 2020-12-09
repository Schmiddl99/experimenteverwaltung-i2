require 'rails_helper'

describe Authorize do
  let(:demo) { Fabricate :user, role: :admin, username: "demo" }
  let(:admin) { Fabricate :user, role: :admin }
  let(:assistant) { Fabricate :user, role: :assistant }
  let(:guest) { Fabricate :user, role: :guest }
  let(:controllers) do
    [
      :categories,
      :experiments,
      :sub_categories,
      :documents,
      :equipment,
      :links,
      :media,
      :users
    ]
  end
  let(:actions) do
    [
      :index,
      :show,
      :new,
      :update,
      :delete
    ]
  end

  it "demo Login wird immer zugelassen" do
    a = Authorize.new(user: demo, controller: "devise/sessions", action: "new")
    expect(a.disallow?).to be_falsey
    a = Authorize.new(user: demo, controller: "devise/sessions", action: "create")
    expect(a.disallow?).to be_falsey
  end

  it "demo geht nicht" do
    a = Authorize.new(user: demo, controller: "users", action: "create")
    expect(a.disallow?).to be_truthy
  end

  it "demo geht" do
    a = Authorize.new(user: demo, controller: "users", action: "index")
    expect(a.disallow?).to be_falsey
  end

  it "Login wird immer zugelassen" do
    a = Authorize.new(controller: "devise/sessions", action: "new")
    expect(a.allow?).to be_truthy
  end

  it "Admin hat Zurgiff auf Alles" do
    controllers.each do |c|
      actions.each do |a|
        a = Authorize.new(user: admin, controller: c, action: a)
        expect(a.allow?).to be_truthy
      end
    end
  end

  it "Assistenten dürfen keine nutzer bearbeiten" do
    [:new, :update].each do |a|
      a = Authorize.new(user: assistant, controller: "users", action: a)
      expect(a.disallow?).to be_truthy
    end
  end

  it "Gast darf nur Experimente und Kategorien ansehen" do
    controllers.first(2).each do |c|
      actions.first(2).each do |a|
        a = Authorize.new(user: guest, controller: c, action: a)
        expect(a.allow?).to be_truthy
      end
    end
  end

  it "Gast darf nichts beabeiten" do
    controllers.last(7).each do |c|
      [:new, :update].each do |a|
        auth = Authorize.new(user: guest, controller: c, action: a)
        expect(auth.disallow?).to be_truthy
      end
    end
  end
end
