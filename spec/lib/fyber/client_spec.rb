require 'rails_helper'

RSpec.describe Fyber::Client do
  before do
    success = YAML.load_file("#{Rails.root}/spec/mocks/success.yml").to_json
    error   = YAML.load_file("#{Rails.root}/spec/mocks/error.yml").to_json
    empty   = YAML.load_file("#{Rails.root}/spec/mocks/empty.yml").to_json
    stub_request(:get, "api.fyber.com/feed/v1/offers.json").with(:query => hash_including({uid: "success"})).to_return(body: success)
    stub_request(:get, "api.fyber.com/feed/v1/offers.json").with(:query => hash_including({uid: "error"})).to_return(body: error, status: 401)
    stub_request(:get, "api.fyber.com/feed/v1/offers.json").with(:query => hash_including({uid: "empty"})).to_return(body: empty)
  end

  describe "#new" do
    context "with wrong arguments" do
      it "should raise argument error if no api key is set" do
        expect{Fyber::Client.new}.to raise_error(ArgumentError)
      end

      it "should raise argument error if no api key is empty" do
        expect{Fyber::Client.new("")}.to raise_error(ArgumentError)
      end

      it "should raise argument error if no api key is not a string" do
        expect{Fyber::Client.new(1)}.to raise_error(ArgumentError)
      end
    end
    context "with right arguments" do
      it "should instanciate a fyber client" do
        client = Fyber::Client.new("api_key")
        expect(client).to be_kind_of(Fyber::Client)
      end
    end
  end

  describe "#get_offers" do
    let(:client){Fyber::Client.new("api_key")}
    let(:params){FYBER['params']}
    context "with wrong arguments" do
      it "should have argument errors if no uid" do
        client.get_offers()
        expect(client.errors[:argument]).not_to be_empty
      end

      it "should have errors if wrong params" do
        client.get_offers(params.merge(uid: 'error'))
        expect(client.errors).not_to be_empty
      end
    end

    context "with right arguments" do
      it "should not have errors" do
        client.get_offers(params.merge(uid: 'success'))
        expect(client.errors).to be_empty
      end

      it "should not have argument errors with correct uid" do
        client.get_offers(params.merge(uid: 'success'))
        expect(client.errors[:argument]).to be_nil
      end

      it "should return offers if they exist" do
        offers = client.get_offers(params.merge(uid: 'success'))
        expect(offers).not_to be_empty
      end

      it "should return no offers if they dont exist" do
        offers = client.get_offers(params.merge(uid: 'empty'))
        expect(offers).to be_empty
      end
    end
  end

end
