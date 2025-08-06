class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]

  def index
    @contents = Content.includes(:tags, :user).all
    @content_stats = Content.group(:content_type).count
  end

  def show
  end

  def new
    @content = Content.new
  end

  def create
    @content = Content.new(content_params.except(:tag_names))
    @content.user_id = 1  # TODO: Replace with current_user.id when authentication is implemented
    
    # Handle tag processing
    if content_params[:tag_names].present?
      tag_names = content_params[:tag_names].split(',').map(&:strip).reject(&:blank?)
      tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
      @content.tags = tags
    end

    if @content.save
      redirect_to @content, notice: 'Content was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Handle tag processing
    if content_params[:tag_names].present?
      tag_names = content_params[:tag_names].split(',').map(&:strip).reject(&:blank?)
      tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
      @content.tags = tags
    end

    if @content.update(content_params.except(:tag_names))
      redirect_to @content, notice: 'Content was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @content.destroy
    redirect_to contents_path, notice: 'Content was successfully deleted.'
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:title, :body, :link, :content_type, :tag_names, :thumbnail)
  end
end