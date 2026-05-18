class AuthController < ApplicationController

  def signup
    user = User.new(user_params)

    if user.save
      token = JWT.encode({ user_id: user.id }, jwt_secret, 'HS256')
      render json: { user: user, token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JWT.encode({ user_id: user.id }, jwt_secret, 'HS256')
      render json: { user: user, token: token }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def jwt_secret
    ENV['JWT_SECRET'] || 'bookvaultsecret'
  end

end