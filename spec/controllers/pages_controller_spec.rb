require 'spec_helper'

describe PagesController do

  describe "GET 'classification'" do
    it "returns http success" do
      get 'classification'
      response.should be_success
    end
  end

end
