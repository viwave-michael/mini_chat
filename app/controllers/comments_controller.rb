class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @comments = Comment.order('created_at DESC')
  end

  def create
    if current_user
      @comment = current_user.comments.build(comment_params)
      @comment.save
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
