class BasesController < ApplicationController
  before_action :admin_user, only: :index
  
  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報を作成しました。"
      redirect_to bases_url
    else
      render :new
    end
  end
  
  def edit
    @base = Base.find(params[:id])
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to bases_path
    else
      render :edit
    end
  end
  
  def destroy
    @base = Base.find(params[:id])
    @base.destroy
    flash[:success] = "拠点情報を削除しました。"
    redirect_to bases_path
  end
  
  private
  
    def base_params
      params.require(:base).permit(:base_name, :base_number, :attendance_type)
    end
end
