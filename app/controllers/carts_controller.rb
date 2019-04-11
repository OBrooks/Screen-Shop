class CartsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  after_action :add_user, except: [:different_shipping_adress, :add_shipping_adress, :update_shipping_infos, :display_form_edit_shipping_address]

  def index
    @carts = Cart.all
  end

  def show
    @deliveries = Delivery.all
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
      respond_to do |format|
        format.html { redirect_to @cart, notice: 'La livraison a été mise à jour' }
        format.js {}
        format.json { render :show, status: :ok, location: @cart }
    end
  end

  def destroy
    line_items = LineItem.where(cart_id: @cart.id)
    line_items.each do |line_item|
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
    end
  end

  #After click on "Payer", use Stripe
  def resume_payment
    if user_signed_in? == false
      redirect_to new_user_session_path
    else
      @cart = Cart.find(params[:id])
      @user = User.find(@cart.user_id)
      puts "Stripe Token est #{params[:stripeToken]}"
      token = params[:stripeToken]
      cart_order = @cart
      # cart_title = params[:title]
      card_brand = @user.card_brand
      card_exp_month = @user.card_exp_month
      card_exp_year  = @user.card_exp_year
      card_last4 = @user.card_last4

      charge = Stripe::Charge.create(
        :amount => 3000,
        :currency => "eur",
        :description => cart_order,
        # :statement_descriptor => job_title,
        :source => token
      )

      current_user.stripe_id = charge.id
      current_user.card_brand = card_brand
      current_user.card_exp_month = card_exp_month
      current_user.card_exp_year = card_exp_year
      current_user.card_last4 = card_last4
      current_user.save!
    end

    respond_to do |format|
      if @cart.save
        @cart.update(status: 1)
        format.html { redirect_to @job, notice: 'La commande a été passée avec succès !' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end

    rescue Stripe::CardError => e
      flash.alert = e.message
      render action: :new
  end

  def different_shipping_adress
    respond_to do |format|
      format.html { redirect_to @cart}
      format.js { }
    end
      @cart = Cart.find(params[:id])
      @user = User.find(@cart.user_id)
      @shipping_info = ShippingInfo.new
      @shipping_info.user_id = @user.id
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

  def add_shipping_adress
    puts "Les params du add shipping sont #{params}"
    puts "Le current est #{current_user.id}"
    @user = current_user
    @shipping_info = ShippingInfo.create!(user_id: @user.id, street_number: 1)
    @adress_for_cart = AdressForCart.create!(cart_id: params[:cart_id], shipping_info_id: @shipping_info.id)
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
end
