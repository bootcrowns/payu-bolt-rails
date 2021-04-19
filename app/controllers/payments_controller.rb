$returnUrl	= 'http://localhost:3000/payments/callback' # change is as required by your app

class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callback]

  def index
    json = {}
    @key = Rails.application.credentials.payu[:key]
    @salt = Rails.application.credentials.payu[:salt]
    @txnid = "ORD#{rand(1000..9000)}"
    @email = 'test@able.do'
    @fname = 'Tester'
    @phone = '9999999999'
    @amount = '100'
    @pinfo = 'P01,P02'
    @udf5 = "BOLT_KIT_ROR"

    json[:key] = @key
    json[:salt] = @salt
    json[:txnid] = @txnid
    json[:amount] = @amount
    json[:pinfo] = @pinfo
    json[:fname] = @fname
    json[:email] = @email
    json[:udf5] = @udf5
    @hash = calchash(json)


  end

  def calchash(params)
    data =	params[:key] + '|' + params[:txnid] + '|' + params[:amount] + '|' + params[:pinfo] + '|' + params[:fname] + '|' + params[:email] + '|||||' + params[:udf5] + '||||||' + params[:salt]

    Digest::SHA512.hexdigest(data)
  end

  # to be called by PayU to post response
  def callback
    byebug
    @key = params[:key]
    @salt = params[:salt]
    @txnid = params[:txnid]
    @amount = params[:amount]
    @pinfo = params[:productinfo]
    @fname = params[:firstname]
    @email = params[:email]
    @udf5 = params[:udf5]
    @mihpayid = params[:mihpayid]
    @status = params[:status]
    @hash = params[:hash]

    # Verify response hash
    data = '|||||' + @udf5 + '|||||' + @email + '|' + @fname + '|' + @pinfo + '|' + @amount + '|' + @txnid + '|' + @key

    @CalcHash	= Digest::SHA512.hexdigest(@salt + '|' + @status + '|' + data)

    @msg = 'Payment failed for Hasn not verified...'

    @msg = 'Transaction Successful and Hash Verified...' if @status === 'success' && @hash === @CalcHash
  end
  # end of response
end
