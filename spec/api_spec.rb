require File.dirname(__FILE__) + '/spec_helper'

describe APICache::API do
  before :each do
    @options = {
      :period => 1,
      :timeout => 5
    }
  end

  it "should not be queryable? for :period seconds after a request" do
    api = APICache::API.new('http://www.google.com/', @options)
    api.should be_queryable
    api.get
    api.should_not be_queryable
    sleep 1
    api.should be_queryable
  end

  describe "without a block - key is the url" do

    it "should return body of a http GET against the key" do
      api = APICache::API.new('http://www.google.com/', @options)
      api.get.should =~ /Google/
    end

    it "should handle redirecting get requests" do
      api = APICache::API.new('http://froogle.google.com/', @options)
      api.get.should =~ /Google Product Search/
    end

  end

  describe "with a block" do

    it "should return the return value of the block" do
      api = APICache::API.new('http://froogle.google.com/', @options) do
        42
      end
      api.get.should == 42
    end

  end
end
