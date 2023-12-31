# frozen_string_literal: true

# USER
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :profile_image
  has_one :personal_detail, as: :bio
  has_one_attached :avatar
  accepts_nested_attributes_for :personal_detail
  # after_create :full_name_set
  # after_update :full_name_set

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: {
    super_admin: 0,
    admin: 1,
    customer: 2
  }, _prefix: true

  validates :email, format: { with: Devise.email_regexp }

  attr_accessor :limit

  def self.filter_role(current_user)
    if current_user.role_super_admin?
      %w[admin staff]
    else
      ['staff']
    end
  end

  def self.to_csv
    attributes = all.column_names
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  def full_name_set
    full_name = personal_detail.first_name + ' ' + personal_detail.last_name
    personal_detail.update_columns(full_name: full_name)
  end
end
