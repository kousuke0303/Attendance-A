class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforeフィルター
    
  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end

  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
    store_location
    flash[:danger] = "ログインしてください。"
    redirect_to login_url
    end
  end
  
  # ログイン済みユーザーのアクセス制限
  def logged_in_user_not
    if logged_in?
      flash[:info] = "すでにログインしています。"
      redirect_to root_url if logged_in?
    end
  end
  
  # ログイン中のアカウント作成制限
  def only_admin_or_once
    if logged_in? && !current_user.admin?
      flash[:info] = "すでにアカウント作成済です。"
      redirect_to root_url
    end
  end
  
  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to(root_url) unless current_user && current_user.admin?
  end
  
  # 管理権限者、または現在ログインしているユーザーを許可します。
  def superior_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.superior?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end
  end
  
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    
    unless one_month.count == @attendances.count
       ActiveRecord::Base.transaction do
         one_month.each { |day| @user.attendances.create!(worked_on: day) }
       end
       @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
    
  rescue ActiveRecord::RecordInvalid 
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end
