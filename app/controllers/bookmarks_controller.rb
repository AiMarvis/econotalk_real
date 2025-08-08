class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content, only: [:create, :destroy]
  
  def index
    @bookmarks = current_user.bookmarks.includes(:content) if user_signed_in?
  end
  
  def create
    @bookmark = current_user.bookmarks.build(content: @content)
    
    respond_to do |format|
      if @bookmark.save
        format.turbo_stream { render_bookmark_button }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark_#{@content.id}", partial: "bookmarks/error", locals: { content: @content }) }
      end
    end
  end
  
  def destroy
    @bookmark = current_user.bookmarks.find_by(content: @content)
    @bookmark&.destroy
    
    respond_to do |format|
      format.turbo_stream { render_bookmark_button }
    end
  end
  
  private
  
  def set_content
    @content = Content.find(params[:content_id])
  end
  
  def render_bookmark_button
    render turbo_stream: turbo_stream.replace(
      "bookmark_#{@content.id}", 
      partial: "bookmarks/button", 
      locals: { content: @content, user: current_user }
    )
  end
end