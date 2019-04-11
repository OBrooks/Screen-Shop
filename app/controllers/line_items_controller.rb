class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  before_action :set_cart, only: [:create]
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    if product.quantity.to_i < (params[:line_item][:quantity]).to_i
      redirect_to product_path(product.id), notice: "La quantité en stock n'est pas suffisante, il ne reste que #{product.quantity} unité(s)"
    else
      @line_item = LineItem.find_by(cart_id: @cart.id, product_id: product.id)
      puts
      puts "Le @line_item est #{@line_item}"
      puts
      if @line_item != nil
        redirect_to request.referrer, notice: "Ce produit est déjà dans votre panier"
        
      else
        @line_item = @cart.add_product(product)

        #Update product quantity
        new_quantity = product.quantity.to_i - (params[:line_item][:quantity]).to_i
        product.update(quantity: new_quantity)
        @line_item.update(quantity: params[:line_item][:quantity])
        
        respond_to do |format|
          if @line_item.save
            format.html {  redirect_to products_path, notice: 'Le produit a été ajouté au panier' }
            format.json { render :show, status: :created, location: @line_item }
          else
            format.html { render :new }
            format.json { render json: @line_item.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end


  def update
    @cart = Cart.find(params[:line_item][:cart_id])

    product = Product.find(@line_item.product_id)
    new_asked_quantity = (params[:line_item][:quantity]).to_i - @line_item.quantity.to_i
    if product.quantity.to_i < new_asked_quantity.to_i
      redirect_to @line_item.cart, notice: "La quantité en stock n'est pas suffisante, il ne reste que #{product.quantity} unité(s)"
    else
    #Update product quantity
    new_quantity = product.quantity.to_i - new_asked_quantity.to_i
    product.update(quantity: new_quantity)

      respond_to do |format|
        if @line_item.update(quantity: params[:line_item][:quantity])
          format.html { redirect_to @line_item.cart, notice: "L'article a été mis à jour" }
          format.json { render :show, status: :ok, location: @line_item }
          format.js   { }
        else
          format.html { render :edit }
          format.json { render json: @line_item.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @cart = Cart.find(session[:cart_id])
    product = Product.find(@line_item.product_id)
    #Update product quantity
    new_quantity = product.quantity.to_i + @line_item.quantity.to_i
    product.update(quantity: new_quantity)
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to @line_item.cart, notice: "L'article a été retiré" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
end
