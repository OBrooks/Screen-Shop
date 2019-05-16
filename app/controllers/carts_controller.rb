class CartsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  after_action :add_user, except: [:different_shipping_adress, :add_shipping_adress, :update_shipping_infos, :display_form_edit_shipping_address, :select_shipping_adress, :apply_coupon]

  def index
    @carts = Cart.all
  end

  def show
    @deliveries = Delivery.all
    discount_code_applied
  end

  def new
    @cart = Cart.new
  end

  def edit
  end

  def create
    @cart = Cart.new(cart_params)
    
    if current_user != nil
      @cart.update(user_id: current_user.id)
    end

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  #Form to update the delivery infos in js
  def update_delivery
    @cart = Cart.find(params[:cart][:id])
    @cart.update(delivery_id: params[:cart][:delivery_id])
    discount_code_applied
      respond_to do |format|
        format.html { redirect_to @cart, notice: 'La livraison a été mise à jour' }
        format.js {}
        format.json { render :show, status: :ok, location: @cart }
    end
  end

  def destroy
    @line_items = LineItem.where(cart_id: @cart.id)
    @adress_for_cart = AdressForCart.find_by(cart_id: @cart.id)
    if @adress_for_cart != nil
      @adress_for_cart.destroy
    end
    @line_items.each do |line_item|
      product = Product.find(line_item.product_id)
      new_quantity = product.quantity.to_i + line_item.quantity.to_i
      product.update(quantity: new_quantity)
    end
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Le panier a été entièrement vidé' }
      format.json { head :no_content }
    end
  end

  #After payment, gather all infos
  def resume
    if user_signed_in? == false
      redirect_to new_user_session_path
    else
      @cart = Cart.find(params[:id])
      total_price_without_currency
      @user = current_user
      @shipping_infos = ShippingInfo.where(user_id: @user.id)
      @shipping_info = ShippingInfo.find_by(user_id: @user.id)
      @adress_for_cart = AdressForCart.find_by(cart_id: @cart.id)
      if @shipping_info == nil
        @shipping_info = ShippingInfo.create!(user_id: @user.id,
                                            first_name: @user.first_name,
                                            last_name: @user.last_name,
                                            street_number: @user.street_number,
                                            street_name: @user.street_name, 
                                            street_name2: @user.street_name2, 
                                            zip_code: @user.zip_code, 
                                            city: @user.city,
                                            phone_number: @user.phone_number)
        if @user.gender == "male"
          @shipping_info.update(civility: "Monsieur")
        elsif @user.gender == "female"
          @shipping_info.update(civility: "Madame")
        end
      end
      if @adress_for_cart != nil
        @billing_info = BillingInfo.find_by(id: @adress_for_cart.billing_info_id)
      else
        @adress_for_cart = AdressForCart.create!(cart_id: @cart.id, shipping_info_id: @shipping_info.id)
        @billing_info == nil
      end
    end
  end

  #Verify coupon
    # ---> Have to apply the update to
  def apply_coupon
    @cart = Cart.find(params[:id])
    @discount_codes = DiscountCode.all
    @discount_codes.each do |code|
      if code.code == params[:coupon_code]
        @discount_code = code
      end
    end
    @errorCoupon = []
    respond_to do |format|
      if @discount_code != nil && @discount_code.start_date.to_datetime <= Time.now && @discount_code.end_date.to_datetime >= Time.now
          @cart.update(discount_code_id: @discount_code.id)
          discount_code_applied
          @errorCoupon.push("Coupon validé !")
          format.html { redirect_to cart_path }
          format.json { render :show, status: :created, location: @cart.model }
          format.js {render 'coupon_good'}
      else
        puts "in the bad else"
        if @discount_code == nil
          @errorCoupon.push("Le coupon est inexistant")
        end
        if @discount_code != nil
          if @discount_code.start_date.to_datetime > Time.now
            @errorCoupon.push("La date de validité du coupon n'a pas débuté")
          end
          if @discount_code.end_date.to_datetime < Time.now
            @errorCoupon.push("Le coupon est expiré")
          end
        end
        puts "Before html et tout le"
        format.html { render :new }
        format.json {}
        format.js   {render 'coupon_error'}
      end
    end
  end

  #After click on "Procéder au paiement", use Stripe
  def resume_payment
    if user_signed_in? == false
      redirect_to new_user_session_path
    else
      @cart = Cart.find(params[:id])
      # Create billing_infos if it's nil
      @billing_info = BillingInfo.find_by(user_id: current_user.id)
      if @billing_info != nil
      puts "Les billings infos sont #{@billing_info.id}"
      else
        puts "c'est nil le billing"
      end
      if @billing_info == nil
        create_billing_idem
      end
      puts "Les billings infos after sont #{@billing_info.id}"

      @user = current_user
      token = params[:stripeToken]
      cart_order = @cart.id
      card_brand = @user.card_brand
      card_exp_month = @user.card_exp_month
      card_exp_year  = @user.card_exp_year
      card_last4 = @user.card_last4

      # Save card infos for later
      if params[:save_card_infos] == 1
        # New customer
        if @user.stripe_customer == nil
          customer = Stripe::Customer.create({
              source: token,
              email: @user.email,
          })
          @user.update(stripe_customer: customer.id)
        end
        customer_id = @user.stripe_customer
        # New card infos
        if @user.card_last4 != params[:user][:card_last4] && @user.card_exp_month != params[:user][:card_exp_month] && @user.card_exp_year != params[:user][:card_exp_year] && @user.card_brand != params[:user][:card_brand]
          puts "In user different informations"
          Stripe::Customer.update(@user.stripe_customer,
                                  :source => token)
        puts "end of update"
        else
          puts "In new charge with same payment method"
        end
          charge = Stripe::Charge.create(
            :amount => params[:cart_total_price],
            :currency => "eur",
            :description => "Screen-Shop Order n°#{cart_order}",
            :customer => customer_id
          )

        puts "Coucou charge #{charge}"
        puts "Coucou card_brand #{charge[:source][:brand]}"
        puts "Coucou exp_month #{charge[:source][:exp_month]}"
        puts "Coucou exp_year #{charge[:source][:exp_year]}"
        puts "Coucou last4 #{charge[:source][:last4]}"

        current_user.stripe_id = charge.id
        current_user.card_brand = charge[:source][:brand]
        current_user.card_exp_month = charge[:source][:exp_month]
        current_user.card_exp_year = charge.source.exp_year
        current_user.card_last4 = charge.source.last4
        current_user.card_stripe_number = charge.payment_method
        current_user.save!
        puts "Le stripe Id est #{current_user.stripe_id}"
        puts "Le card exp year est #{current_user.card_exp_year}"
        puts "Le card last 4 est #{current_user.card_last4}"
        puts "Le Card Stripe est #{current_user.card_stripe_number}"
        puts "Le current user est #{current_user}"
      
      else
        # Normal charge without saving the customer and his infos
        puts "In not save card"
        puts "Le coût est de #{params[:cart_total_price]}"
          charge = Stripe::Charge.create(
          :amount => params[:cart_total_price],
          :currency => "eur",
          :description => "Screen-Shop Order n°#{cart_order}",
          :source => token
          )
      end
    end
    puts "Ready to balancer la sauce"
    puts "#{charge.paid}"
    respond_to do |format|
      if charge.paid == true
        puts "in charge good"
        @cart.update(status: 1)
        @adress_for_cart = AdressForCart.find_by(cart_id: @cart.id)
        @billing_info = BillingInfo.find_by(user_id: @user.id)
        @order = Order.create!( user_id: @user.id,
                                shipping_info_id: @adress_for_cart.shipping_info_id,
                                delivery_id: @cart.delivery_id,
                                billing_info_id: @billing_info.id)
        @line_items = LineItem.where(cart_id: @cart.id)
        @line_items.each do |line_item|
          line_item_order = LineItemsOrder.create!(product_id: line_item.product_id, order_id: @order.id, quantity: line_item.quantity, price: line_item.product.price, discount: line_item.product.discount)
          line_item.destroy
        end
        @adress_for_cart.destroy
        @cart.destroy
        UserMailer.order_summary(@order).deliver_later
        format.html { redirect_to root_path, notice: 'La commande a été passée avec succès !' }
        format.json { render :show, status: :created, location: @cart }
      else
        puts "in charge pas good"
        format.html { redirect_to root_path, notice: "Il y a eu un problème avec le paiement, votre commande n'a pas été passée" }
        format.js {render inline:"location.reload();", notice: "Le code n'est pas valable"}
      end
    end

    rescue Stripe::CardError => e
      flash.alert = e.message
      render action: :new
  end

  def update_shipping_infos
    @shipping_info = ShippingInfo.find(params[:shipping_info][:id])
    if @shipping_info == nil
      @shipping_info = ShippingInfo.new
    end
    @shipping_info.user_id = current_user.id
    @shipping_info.update(civility: params[:shipping_info][:civility],
                            first_name: params[:shipping_info][:first_name],
                            last_name: params[:shipping_info][:last_name],
                            street_number: params[:shipping_info][:street_number],
                            street_name: params[:shipping_info][:street_name], 
                            street_name2: params[:shipping_info][:street_name2], 
                            zip_code: params[:shipping_info][:zip_code], 
                            city: params[:shipping_info][:city],
                            main_adress: params[:shipping_info][:main_adress])
      if params[:shipping_info][:main_adress] == 1
        current_user.update(last_name: params[:shipping_info][:last_name],
                            street_number: params[:shipping_info][:street_number],
                            street_name: params[:shipping_info][:street_name], 
                            street_name2: params[:shipping_info][:street_name2], 
                            zip_code: params[:shipping_info][:zip_code], 
                            city: params[:shipping_info][:city])
      end
      @shipping_infos = ShippingInfo.where(user_id: current_user.id)
      @cart= Cart.find(params[:shipping_info][:cart_id])
      @adress_for_cart = AdressForCart.find_by(cart_id: @cart.id)

      respond_to do |format|
        format.html { redirect_to @cart}
        format.js {render inline: "location.reload();"  }
      end
  end

  def select_shipping_adress
    puts "Les params du select sont #{params}"
    @adress_for_cart = AdressForCart.find_by(cart_id: params[:cart_id])
    if @adress_for_cart == nil
      @adress_for_cart = AdressForCart.create!(cart_id: params[:cart_id], shipping_info_id: params[:shipping_info_id]) 
    else
      @adress_for_cart.update(shipping_info_id: params[:shipping_info_id])
    end
    respond_to do |format|
      format.html { redirect_to @cart}
      format.js { }
    end
  end


  def display_form_edit_shipping_address
    @shipping_info_id = params[:shipping_info_id]
    @shipping_info = ShippingInfo.find(params[:shipping_info_id])
    @cart = Cart.find(params[:cart_id])
    respond_to do |format|
      format.html { redirect_to @cart}
      format.js { }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.fetch(:cart, {})
    end

    def invalid_cart
      logger.error "Vous avez essayé d'accéder à un panier invalide #{params}"
      redirect_to root_path, notice: "Ce panier n'existe pas"
    end

    def add_user
      puts "in add_user"
      puts "Les params sont #{params}"
      if current_user != nil && @cart.user_id == nil
        @cart.update(user_id: current_user.id)
      end
    end

    def create_billing_idem
      main_address = ShippingInfo.find_by(user_id: current_user.id, main_adress: true)
      if main_address != nil
        @shipping_info = main_address
        puts "In main address"
      else
        puts "In adress for cart"
        @adress_for_cart = AdressForCart.find_by(cart_id: @cart.id)
        @shipping_info = ShippingInfo.find(@adress_for_cart.shipping_info_id)
      end
      @billing_info = BillingInfo.create!(civility: @shipping_info.civility,
                                          first_name: @shipping_info.first_name,
                                          last_name: @shipping_info.last_name,
                                          street_number: @shipping_info.street_number,
                                          street_name: @shipping_info.street_name, 
                                          street_name2: @shipping_info.street_name2, 
                                          zip_code: @shipping_info.zip_code, 
                                          city: @shipping_info.city,
                                          phone_number: @shipping_info.phone_number,
                                          email: current_user.email,
                                          user_id: current_user.id)
                                          puts "Billing Id est #{@billing_info.id}"
    end

    private

      #Discount Code applied
    def discount_code_applied
      @discount_code = @cart.discount_code
      @sub_total = @cart.sub_total_price
      if @cart.discount_code != nil && @cart.delivery != nil
        @total_discount = @sub_total * ((@discount_code.discount.to_d/100))
        @total = ActionController::Base.helpers.number_to_currency(@sub_total - @total_discount + @cart.delivery.price)
      elsif @cart.discount_code != nil && @cart.delivery == nil
        @total_discount = @sub_total * ((@discount_code.discount.to_d/100))
        @total = "Veuillez choisir une livraison"
      elsif @cart.delivery != nil && @cart.discount_code == nil
        @total = ActionController::Base.helpers.number_to_currency(@sub_total + @cart.delivery.price)
      else
        @total = "Veuillez choisir une livraison"
      end
    end

    def total_price_without_currency
      discount_code_applied
      puts
      puts "Le total est #{@total}"
      puts
      @total_price_without_currency = currency_to_number(@total)
      puts "Le total sans monnaie est #{@total_price_without_currency}"
    end

    def currency_to_number(currency_value)
      (currency_value.is_a? String) ? currency_value.scan(/[.0-9]/).join.to_i : currency_value
    end
end
