class PostsController < ApplicationController
  before_action :set_forced_post, only: %i[edit update]
  before_action :set_post, only: :index

  def update
    return render :edit unless @post.update post_params
    redirect_to :root
  end

  private

  def calculated_timestamp
    relevant_until = DateTime.parse @post_params[:relevant_until]
    relevant_until = 5.seconds.since Time.now if relevant_until < Time.now
    relevant_until
  end

  def post_params
    @post_params = params.require(:post).permit :title, :description, :relevant_until
    @post_params.merge forced: true, relevant_until: calculated_timestamp, posted_at: Time.now
  end

  def set_forced_post
    @post = Post.forced || Post.new
  end

  def set_post
    @post = Post.relevant || YandexService.new.update_news
  end
end
