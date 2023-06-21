# frozen_string_literal: true

# dashboard
class HomeController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @total_counts = { products_count: '100+', suppliers_count: '100+',
                      purchase_orders_count: '100+', purchase_deliveries_count: '100+' }
  end
end
