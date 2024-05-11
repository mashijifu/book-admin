class BooksController < ApplicationController
  protect_from_forgery expect: [:destroy]
  before_action :set_book, only: [:show, :destroy]
  # フックにメソッド名を指定する以外に、ブロックを用いてフックを定義することもできる
  # before_action do
  #   redirect_to access_denied_path if params[:token].blank?
  # end
  around_action :action_logger, only: [:destroy]

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def destroy
    @book.after_destroy
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { head :no_content }
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def action_logger
    logger.info "around-before"
    yield
    logger.info "around_after"
  end
end
