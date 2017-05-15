class Api::SubscriptionsController < Api::BaseController
  def create
    @subscription = Subscription.create(subscription_params)

    if @subscription.valid?
      render :json => { :success => true }
    else
      render :json => { :errors => @subscription.errors.full_messages }, :status => 422
    end
  end

  private

    def subscription_params
      params.permit(:email, :phone_number, :call, :text, :first_name, :last_name, :zip, :language, :tdd)
    end
end
