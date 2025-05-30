class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create] # ログインしているかどうかを判断

  def index
    @posts = Post.limit(10).order(created_at: 'desc')
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new # 新規投稿用のインスタンス変数を用意
  end

  def create
    @post = Post.new(post_params) # ストロングパラメータを使ってフォームから受け取ったパラメータを許可
    @post.user_id = current_user.id # ログインユーザのIDを代入して関連付け

    if @post.save
      flash[:notice] = '投稿しました' # 成功時のフラッシュメッセージ
      redirect_to posts_path # 一時的にトップページへリダイレクト(後に修正)
    else
      flash[:alert] = '投稿に失敗しました' # 失敗時のフラッシュメッセージ
      render :new # 投稿画面を再表示
    end
  end

  def destroy
    # 削除対象の投稿を取得
    post = Post.find_by(id: params[:id])

    # 投稿者とログインユーザーが一致するかを確認
    if post.user == current_user
      post.destroy
      flash[:notice] = '投稿が削除されました'
    end

    # 投稿一覧ページにリダイレクト
    redirect_to posts_path
  end

  private

  # ストロングパラメータで許可するカラムを指定
  def post_params
    params.require(:post).permit(:title, :content) # title と content のみ許可
  end
end
