require "redd/objects/user"

RSpec.describe Redd::Clients::Unauthenticated::Users do
  let(:client) { Redd::Clients::Unauthenticated.new }
  let(:user) { client.user("Mustermind") }

  it "returns a user" do
    expect(user).to be_a(Redd::Objects::User)
  end

  it "has the correct username" do
    expect(user.name).to eq("Mustermind")
  end
end