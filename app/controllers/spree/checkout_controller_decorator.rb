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
        Rails.logger.info "#{current_order.id }--> #{cookies[:affiliate]} >>>> #{current_order.referred_order.inspect}"*200
      if cookies[:affiliate]
        return if current_order.referred_order.present?
        affiliate = Spree::Affiliate.find_by(path: cookies[:affiliate])
        Spree::ReferredOrder.create(user_id: spree_current_user.id, order_id: current_order.id, affiliate_id: affiliate.id)
        Rails.logger.info "#{current_order.id }--> #{cookies[:affiliate]} "*200
      else
        if current_order.referred_order
          Spree::ReferredOrder.find_by(order_id: current_order.id).destroy
        end
      end
    end

  end
end