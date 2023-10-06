RSpec.shared_examples "user authentication" do
    context "when user is not authenticated" do
      it "returns a 401 Unauthorized response" do
        action.call      
        expect(response).to have_http_status(401)    
      end
    end
end