module Spree
  CheckoutController.class_eval do
    before_action :create_referred_order_if_referred, only: [:edit]


    # def process_affiliate_earning
    #   affiliate_id_from_cookie = cookies[Spree::Config[:cookie_name]]
    #   # make sure we aren't giving ourself credit
    #   if affiliate_id_from_cookie &&
    #       affiliate_id_from_cookie != @order.user.affiliate_id
    #     @order.affiliate_earning = AffiliateEarning.create
    #     earning = @order.affiliate_earning
    #     earning.order_id = @order.id
    #     earning.user_id = (Spree::User.where(:affiliate_id => affiliate_id_from_cookie).first).id rescue nil
    #     earning.status = "created"
    #     earning.percentage = Spree::Config[:referal_incentive]
    #     earning.amount = (Spree::Config[:referal_incentive].to_d/100) * @order.total

    #     earning.save
    #   end
    # end

    def create_referred_order_if_referred
      if cookies[:affiliate]
        if current_order.referred_order.present?
          save_referred_products
        elsif (current_order.product_ids & session[:affiliated_products]).any?
          save_referred_order
          save_referred_products
        end
      else
        if current_order.referred_order
          destroy_refered_products
          Spree::ReferredOrder.find_by(order_id: current_order.id).destroy
        end
      end
    end

    def save_referred_products
      referred_product_ids = (current_order.product_ids & session[:affiliated_products])
      return unless referred_product_ids.any?
      if current_order.referred_order.referred_products
        current_order.referred_order.referred_products.where.not(product_id: referred_product_ids).destroy_all
      end
      referred_product_ids.each do | prod|
        ref_product = current_order.referred_order.referred_products.find_or_initialize_by(product_id: prod)
        ref_product.save
      end
    end

    def save_referred_order
      affiliate = Spree::Affiliate.find_by(path: cookies[:affiliate])
      referred_order = Spree::ReferredOrder.new(order_id: current_order.id, affiliate_id: affiliate.id)
      referred_order.user_id = spree_current_user.id if spree_current_user
      referred_order.save!
      # Rails.logger.info "#{current_order.id }--> #{cookies[:affiliate]} "*200
    end

    def destroy_refered_products
      if current_order.referred_order.refered_products
        current_order.referred_order.refered_products.destroy_all
      end
    end

  end
end