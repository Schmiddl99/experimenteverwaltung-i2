require "rails_helper"

describe DummyExperiment do
  it "validate name" do
    dummy_experiment = DummyExperiment.new
    expect(dummy_experiment).to_not be_valid
    expect(dummy_experiment.errors.messages.keys).to include(:name)

    dummy_experiment.name = "Dummy Experiment"
    expect(dummy_experiment).to be_valid
    expect(dummy_experiment.errors.messages.keys).to be_empty
  end
end
