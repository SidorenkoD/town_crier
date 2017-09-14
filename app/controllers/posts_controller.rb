class PostsController < ApplicationController
  before_action :set_forced_post, only: %i[show update]
  before_action :set_post, only: :index

  def update
    return redirect_to :root if @post.update post_params
    render :show
  end

  private

  def post_params
    # params.require(:post).permit :title, :description, :relevant_until
    @post_params = params.require(:post).permit :title, :description
    @post_params.merge forced: true, relevant_until: 1.minute.since(Time.now), posted_at: Time.now
  end

  def set_forced_post
    @post = Post.forced || Post.new
  end

  def set_post
    @post = Post.relevant || YandexService.new.update_news
  end
end
