class PostsController < ApplicationController
  before_action :set_forced_post, only: %i[edit update]
  before_action :set_post, only: :index

  def update
    return render :edit unless @post.update post_params
    redirect_to :root
  end

  private

  def post_params
    # params.require(:post).permit :title, :description, :relevant_until # TODO
    @post_params = params.require(:post).permit :title, :description
    @post_params.merge forced: true, relevant_until: 20.seconds.from_now, posted_at: Time.now
  end

  def set_forced_post
    @post = Post.forced || Post.new
  end

  def set_post
    @post = Post.relevant || YandexService.new.update_news
  end
end
