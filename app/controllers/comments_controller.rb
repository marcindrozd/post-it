class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id])
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Comment successfully added!"
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote has been recorded!"
        else
          flash[:error] = "You have already voted on that item."
        end
        redirect_to :back
      end
      format.js
    end
  end
end