# frozen_string_literal: true

class DashboardsController < ApplicationController # :nodoc:
  before_action :authenticate_user!
  def sales; end

  def ecommerce; end

  def analytics; end

  def crm; end

  def project; end

  def search; end

  def products; end

end
