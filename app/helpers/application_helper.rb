# frozen_string_literal: true

module ApplicationHelper # :nodoc:
  def remove_space(data)
    data.present? ? data.reject { |e| e.to_s.empty? }.join(', ') : ' '
  end
end
