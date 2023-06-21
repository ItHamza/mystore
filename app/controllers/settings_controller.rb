# frozen_string_literal: true

# User setting page for available features
class SettingsController < ApplicationController

  def index
    @total_counts = {
      products_count: '100+', users_count: '100+', categories_count: '100+',
      seasons_count: '100+', extra_field_count: '100+', email_count: '100+',
      import_mapping: '100+', courier: '100+', service: '100+', mail_service_rule: '100+',
      export_mapping: '100+', customer: '100+', pick_and_pack: '100+',
      product_location_mapping: '100+', channel_forecastings: '100+', sellings: '100+',
      customized_rules: '100+', general_settings: '100+', return_reasons: '100+'
    }
  end
end
