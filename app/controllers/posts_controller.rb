class PostsController < ApplicationController
  before_action :set_forced_post, only: %i[edit update]
  before_action :set_post, only: :index

  def update
    return render :edit unless @post.update post_params
    ActionCable.server.broadcast 'newsletter_channel',
                                 title: @post.title,
                                 description: @post.description,
                                 date: @post.posted_at
    redirect_to :root
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
