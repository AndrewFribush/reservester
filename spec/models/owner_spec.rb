require 'spec_helper'

describe Owner do
  let(:owner_params) do
    {
      name:     'Joe',
      email:    'me@here.com',
      password: '12345678',
    }
  end
  after :all do
    Owner.destroy_all
  end

  context "password validation" do
    it "can't be blank" do
      expect {
        Owner.create!(owner_params.merge(password: ""))
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "must be at least 8 characters" do
      expect {
        Owner.create!(owner_params.merge(password: "1234567"))
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "succeeds with valid data" do
      Owner.create!(owner_params)

      owner = Owner.find_by! email: owner_params[:email]
      expect(owner).to_not be_nil
    end
  end

  it "requires name" do
    expect {
      Owner.create!(owner_params.merge(name: ""))
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
