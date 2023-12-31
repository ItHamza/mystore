# frozen_string_literal: true

# Users
class UsersController < ApplicationController
  include ImportExport

  before_action :authenticate_user!
  before_action :user_sub_role
  before_action :find_user, only: %i[edit show destroy]
  before_action :load_resources, only: %i[show edit]
  before_action :update_without_password, only: %i[update]

  def index
    @q = User.where(role: @user_sub_role).ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(params[:limit])
    export_csv(@users) if params[:export_csv].present?
  end

  def new
    @user = User.new
    @personal_detail = @user.build_personal_detail
    @personal_detail.contact_details.build
    @personal_detail.work_details.build
    @personal_detail.study_details.build
  end

  def create
    @user = User.new(user_params)
    @user.update(created_by: current_user.id)
    if @user.save
      flash[:notice] = 'User cerated successfully.'
      redirect_to root_path
    else
      flash.now[:alert] = 'User cannot be create.'
      render 'new'
    end
  end

  def edit; end

  def load_resources
    @personal_detail = @user.personal_detail
    @personal_detail = @user.build_personal_detail if @personal_detail.blank?
    @contact_details = @personal_detail.contact_details
    @personal_detail.contact_details.build if @contact_details.blank?
    @work_details = @personal_detail.work_details
    @personal_detail.work_details.build if @work_details.blank?
    @study_details = @personal_detail.study_details
    @personal_detail.study_details.build if @study_details.blank?
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'User updated successfully.'
      redirect_to root_path
    else
      render 'show'
    end
  end

  def show; end

  def destroy
    @user.destroy

    redirect_to root_path
  end

  def import
    if @csv.present?
      @csv.delete('id')
      @csv.delete('encrypted_password')
      @csv.delete('created_at')
      @csv.delete('updated_at')
      csv_create_records(@csv)
      flash[:notice] = 'File Upload Successful!'
    end
    redirect_to root_path
  end

  def bulk_method
    redirect_to root_path
  end

  def archive
    @q = User.only_deleted.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(params[:limit])
  end

  def restore
    redirect_to root_path
  end

  def profile; end

  def export_csv(users)
    users = users.where(selected: true) if params[:selected]
    request.format = 'csv'
    respond_to do |format|
      format.csv { send_data users.to_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  private

  def user_sub_role
    @user_sub_role = if current_user.role_super_admin?
                       'admin'
                     elsif current_user.role_admin?
                       'staff'
                     end
  end

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user)
          .permit(:email, :password, :password_confirmation, :role, :created_by, :profile_image,
                  personal_detail_attributes:
                  [:id, :first_name, :last_name, :dob, :gender,
                   { contact_details_attributes:
                   %i[id phone_number email street_address city province country zip _destroy],
                     work_details_attributes:
                   %i[id company_name position city description currently_working from to _destroy],
                     study_details_attributes:
                   %i[id school degree format description from to _destroy] }])
  end

  def update_without_password
    return unless params[:user][:password].blank? || params[:user][:password_confirmation].blank?

    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
  end

  def csv_create_records(csv)
    csv.each do |row|
      user = User.with_deleted.create_with(email: row['email'], password: 'Sample',
                                           password_confirmation: 'Sample', role: 'staff')
                 .find_or_create_by(email: row['email'])
      flash[:alert] = "#{user.errors.full_messages} at ID: #{user.id} , Try again " unless update_user(user, row)
    end
  end

  def update_user(user, row)
    user.update(row.to_hash)
  end
end
