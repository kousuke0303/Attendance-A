class PointsController < ApplicationController
  before_action :admin_user
  before_action :set_point, only: [:edit, :update, :destroy]
  
  def index
    @points = Point.all
  end
  
  def new
    @point = Point.new
  end
  
  def create
    @point = Point.new(point_params)
    if @point.save
      flash[:success] = "拠点情報を追加しました。"
      redirect_to points_url
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @point.update_attributes(point_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to points_url
    else
      render :edit
    end
  end
  
  def destroy
    @point.destroy
    flash[:success] = "#{@point.name}を削除しました。"
    redirect_to points_url
  end
  
  def set_point
    @point = Point.find(params[:id])
  end
  
  private
  
    def point_params
      params.require(:point).permit(:name, :number, :kind)
    end
end
