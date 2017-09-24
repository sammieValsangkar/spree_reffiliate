module Spree
  class ReffiliateController < Spree::StoreController
    def referral
      session[:referral] = params[:code]
      redirect_to root_path
    end
    def affiliate
      session[:affiliate] = params[:path]
      cookies[:affiliate] = { :value => params[:path], :expires => Time.now + Spree::Config[:cookie_life_span].to_i.day }
      affiliate = Spree::Affiliate.find_by(:path => params[:path])
      if affiliate.nil? or affiliate.partial.blank? or !partial_exists affiliate.partial
        redirect_to_product_if_exist
      elsif partial_exists affiliate.partial
        render "spree/affiliates/#{affiliate.partial}", :layout => affiliate.get_layout
      end
    end

    private
      def partial_exists partial
        Affiliate.lookup_for_partial lookup_context, partial
      end

      def redirect_to_product_if_exist
        if params[:p]
          product = Spree::Product.published.find_by_slug(params[:p])
          if session[:affiliated_products]
            session[:affiliated_products] << product.id
          else
            session[:affiliated_products] = [ product.id ]
          end
        end
        Rails.logger.info "#{'->>' * 200} #{session[:affiliated_products]}"
        if product
          redirect_to product_path(product)
        else
          redirect_to(root_path)
        end
      end
  end
end
