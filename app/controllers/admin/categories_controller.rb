class Admin::CategoriesController < Admin::BaseController
  before_action :find_category, only: [:edit, :update, :destroy, :sort]
  def index
    @categories = Category.order(position: :asc)
  end

  def new
    @category = Category.new
  end

  def create
    puts params
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: "新增分類成功"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to edit_admin_category_path(@category), notice: "分類更新成功"
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: "分類已刪除"
  end

  def sort
    @category.insert_at(params[:to].to_i + 1)
    render json: {status: "ok"}
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find(params[:id])
  end
end
