class BooksController < ApplicationController

  before_action :authorize

  def index
    render json: @current_user.books
  end

  def create
    book = @current_user.books.new(book_params)

    if book.save
      render json: book, status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    book = @current_user.books.find(params[:id])
    book.destroy
    render json: { message: 'Book deleted' }
  end

  private

  def book_params
    params.permit(:title, :author, :description)
  end

  def authorize
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      decoded = JWT.decode(token, jwt_secret, true, algorithm: 'HS256')
      @current_user = User.find(decoded[0]['user_id'])
    rescue
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def jwt_secret
    ENV['JWT_SECRET'] || 'bookvaultsecret'
  end

end