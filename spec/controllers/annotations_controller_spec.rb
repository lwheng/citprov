require 'spec_helper'

describe AnnotationsController do

  describe "GET 'upload'" do
    it "returns http success" do
      get 'upload'
      response.should be_success
    end
  end

end
