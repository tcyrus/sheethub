# Controller for Orders
class OrdersController < ApplicationController
  SUCCESS_ORDER_PURCHASE_MESSAGE = 'Great success! Thank you for your purchase.'
  CANCEL_ORDER_PURCHASE_MESSAGE = 'Purchase canceled.'
  PURCHASE_INVALID_PAYPAL_EMAIL_MESSAGE = "We could not process your purchase. The uploader's Paypal email is invalid! We've sent the uploader an email. In the meantime, why not take a look at other works on SheetHub?"
  FLAGGED_MESSAGE = 'You cannot purchase a flagged sheet.'
  INVALID_PRICE_MESSAGE = 'Amount must be at least the minimum price.'

  before_action :set_sheet, only: [:checkout]
  before_action :set_order, only: [:status]
  before_action :validate_order_exists, only: [:status]
  before_action :authenticate_user!, only: [:checkout, :status, :cancel]
  before_action :authenticate_owner, only: [:status]
  before_action :validate_flagged, only: [:checkout]
  before_action :validate_min_amount, only: [:checkout]
  before_action :validate_purchase_limits, only: [:checkout]

  def checkout
    track('Checking out sheet', sheet_id: @sheet.id, sheet_title: @sheet.title)
    @order = Order.find_or_initialize_by(user_id: current_user.id,
                                         sheet_id: @sheet.id)
    if @order.completed?
      redirect_to :back, error: "You've already purchased #{@sheet.title}"
    end

    if @sheet.pay_what_you_want && params[:amount].present?
      amount = params[:amount].to_f
      amount_cents = amount * 100
    else
      amount = @sheet.price
      amount_cents = @sheet.price_cents
    end

    author = @sheet.user
    payment_request = build_adaptive_payment_request(@sheet, amount)
    payment_response = get_adaptive_payment_response(payment_request)
    if payment_response.success?
      redirect_url = build_redirect_url(payment_response.payKey)
      @order.update(tracking_id: payment_request.trackingId,
                    payer_id: payment_response.payKey,
                    amount_cents: amount_cents,
                    royalty_cents: Order.calculate_royalty_cents(author, amount_cents),
                    price_cents: @sheet.price_cents)
      redirect_to redirect_url
    else
      Rails.logger.info "Paypal Order Error #{payment_response.error.first.errorId}: #{payment_response.error.first.message}"
      if invalid_account_details?(payment_response)
        OrderMailer.purchase_failure_email(@order).deliver
        flash[:error] = PURCHASE_INVALID_PAYPAL_EMAIL_MESSAGE
      else
        flash[:error] = "We could not process your purchase. #{payment_response.error.first.message}"
      end
      redirect_to sheet_url(@sheet)
    end
  end

  def status
    if @order
      @order.complete if (!@order.completed? && @order.payment_completed?)
      @sheet = @order.sheet
      track('Complete sheet purchase', order_id: @order.id, sheet_id: @sheet.id, sheet_title: @sheet.title)
    else
      fail 'Invalid Tracking Id'
    end
  end

  def thank_you
  end

  def cancel
    track('Cancel sheet purchase')
    redirect_to sheet_url(params[:sheet]), notice: CANCEL_ORDER_PURCHASE_MESSAGE
  end

  private
    def generate_token
      token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless Order.exists?(tracking_id: random_token)
      end
    end

    def build_adaptive_payment_request(sheet, amount)
      author = sheet.user
      tracking_id = generate_token
      api = PayPal::SDK::AdaptivePayments::API.new
      r = api.build_pay
      r.trackingId = tracking_id
      r.actionType = 'PAY'
      r.feesPayer = 'PRIMARYRECEIVER'
      r.cancelUrl = orders_cancel_url(sheet: sheet)
      r.returnUrl = orders_status_url(tracking_id)
      r.currencyCode = 'USD'

      # Primary receiver (Sheet Owner)
      r.receiverList.receiver[0].amount = amount
      r.receiverList.receiver[0].email = sheet.user.paypal_email
      r.receiverList.receiver[0].primary = true

      # Secondary Receiver (Marketplace)
      r.receiverList.receiver[1].amount = Order.calculate_commission(author, amount)
      r.receiverList.receiver[1].email = Rails.application.secrets.paypal_email
      r.receiverList.receiver[1].primary = false
      r
    end

    def get_adaptive_payment_response(payment_request)
      api = PayPal::SDK::AdaptivePayments::API.new
      api.pay(payment_request)
    end

    def build_redirect_url(payKey)
      "https://#{Rails.application.secrets.paypal_domain}/cgi-bin/webscr?cmd=_ap-payment&paykey=#{payKey}"
    end

    def invalid_account_details?(pay_response)
      pay_response.error.first.errorId.in? [580001, 520009]
    end

    def validate_flagged
      return unless @sheet.is_flagged
      flash[:error] = FLAGGED_MESSAGE
      redirect_to root_url
    end

    def validate_purchase_limits
      return if @sheet.in_stock?
      flash[:error] = "#{@sheet.title} is currently out of stock"
      OrderMailer.purchase_out_of_stock_email(@sheet).deliver
      redirect_to @sheet
    end

    def validate_min_amount
      return unless @sheet.pay_what_you_want && params[:amount]
      above_minimum = params[:amount].to_f >= @sheet.price
      return if above_minimum
      flash[:error] = INVALID_PRICE_MESSAGE
      redirect_to @sheet
    end

    def validate_order_exists
      return if @order.present?
      flash[:error] = "That order does not exist."
      redirect_to root_url
    end

    def authenticate_owner
      return if @order.user == current_user
      flash[:error] = "You are not the owner of that order."
      redirect_to root_url
    end

    def set_order
      @order = Order.find_by(tracking_id: params[:tracking_id])
    end

    def set_sheet
      @sheet = Sheet.friendly.find(params[:sheet]) || not_found
    end
end
