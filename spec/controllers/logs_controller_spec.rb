require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe LogsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Log. As you add validations to Log, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "session" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LogsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
  end

  describe "GET show" do
    it "assigns the requested log as @log" do
      log = Log.create! valid_attributes
      get :show, {:id => log.to_param}, valid_session
      expect(assigns(:log)).to eq(log)
    end
  end

  describe "GET new" do
    it "assigns a new log as @log" do
      get :new, {}, valid_session
      expect(assigns(:log)).to be_a_new(Log)
    end
  end

  # Edit log not allowed
  # describe "GET edit" do
  #   it "assigns the requested log as @log" do
  #     log = Log.create! valid_attributes
  #     get :edit, {:id => log.to_param}, valid_session
  #     expect(assigns(:log)).to eq(log)
  #   end
  # end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Log" do
        expect {
          post :create, {:log => valid_attributes}, valid_session
        }.to change(Log, :count).by(1)
      end

      it "assigns a newly created log as @log" do
        post :create, {:log => valid_attributes}, valid_session
        expect(assigns(:log)).to be_a(Log)
        expect(assigns(:log)).to be_persisted
      end

      it "redirects to the created log" do
        post :create, {:log => valid_attributes}, valid_session
        expect(response).to redirect_to(Log.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved log as @log" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Log).to receive(:save).and_return(false)
        post :create, {:log => { "session" => "invalid value" }}, valid_session
        expect(assigns(:log)).to be_a_new(Log)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Log).to receive(:save).and_return(false)
        post :create, {:log => { "session" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  # Update log not allowed
  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested log" do
  #       log = Log.create! valid_attributes
  #       # Assuming there are no other logs in the database, this
  #       # specifies that the Log created on the previous line
  #       # receives the :update_attributes message with whatever params are
  #       # submitted in the request.
  #       expect_any_instance_of(Log).to receive(:update).with({ "session" => "MyString" })
  #       put :update, {:id => log.to_param, :log => { "session" => "MyString" }}, valid_session
  #     end

  #     it "assigns the requested log as @log" do
  #       log = Log.create! valid_attributes
  #       put :update, {:id => log.to_param, :log => valid_attributes}, valid_session
  #       expect(assigns(:log)).to eq(log)
  #     end

  #     it "redirects to the log" do
  #       log = Log.create! valid_attributes
  #       put :update, {:id => log.to_param, :log => valid_attributes}, valid_session
  #       expect(response).to redirect_to(log)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the log as @log" do
  #       log = Log.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       allow_any_instance_of(Log).to receive(:save).and_return(false)
  #       put :update, {:id => log.to_param, :log => { "session" => "invalid value" }}, valid_session
  #       expect(assigns(:log)).to eq(log)
  #     end

  #     # it "re-renders the 'edit' template" do
  #     #   log = Log.create! valid_attributes
  #     #   # Trigger the behavior that occurs when invalid params are submitted
  #     #   allow_any_instance_of(Log).to receive(:save).and_return(false)
  #     #   put :update, {:id => log.to_param, :log => { "session" => "invalid value" }}, valid_session
  #     #   expect(response).to render_template("edit")
  #     # end
  #   end
  # end

  # Delete log not allowed
  # describe "DELETE destroy" do
  #   it "destroys the requested log" do
  #     log = Log.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => log.to_param}, valid_session
  #     }.to change(Log, :count).by(-1)
  #   end

  #   it "redirects to the logs list" do
  #     log = Log.create! valid_attributes
  #     delete :destroy, {:id => log.to_param}, valid_session
  #     expect(response).to redirect_to(logs_url)
  #   end
  # end

end
