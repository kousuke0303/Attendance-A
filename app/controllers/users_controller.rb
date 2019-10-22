class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy,
                                  :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :superior_or_correct_user, only: :show
  before_action :only_admin_or_once, only: [:new, :create]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info,
                                    :attendancing_index, :import]
  before_action :set_one_month, only: :show
  
  def index
    @users = User.all.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    respond_to do |format|
      format.html do
          #html用の処理を書く
      end 
      format.csv do
          #csv用の処理を書く
          send_data render_to_string, filename: "#{@attendances[0].worked_on.year}-#{@attendances[0].worked_on.month}.csv", type: :csv
      end
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}を削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
      redirect_to users_path
    else
      render :edit_basic_info
    end
  end
  
  def attendancing_index
    @users = User.includes(:attendances).where(attendances: { worked_on: Date.current, finished_at: nil })
                                        .where.not(attendances: { started_at: nil })
  end
  
  def import
    current_user_count = User.count
    if params[:file].blank?
      flash[:danger] = "ファイルを選択してください。"
      redirect_to users_url
    elsif
      User.import(params[:file])
      new_user_count = User.count - current_user_count
      flash[:success] = "#{new_user_count}件のデータを登録しました。"
      redirect_to users_url
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid,
                                   :password, :password_confirmation, :basic_work_time,
                                   :designated_work_start_time, :designated_work_end_time)
    end
end
