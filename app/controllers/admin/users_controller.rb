module Admin
  class UsersController < BaseController
    before_action :base_scope
    before_action :set_user, only: %i[show edit update destroy]

    def index
      authorize(User.all)
      @pagy, @users = pagy(User.order(created_at: :desc))
    end

    def show; end

    def new
      @user = User.new
      authorize(@user)
    end

    def edit; end

    def create
      @user = User.new(user_params)

      authorize(@user)

      if @user.save
        redirect_to admin_user_path(@user), notice: 'User was successfully created.'
      else
        render :new
      end
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @user.destroy!
      redirect_to admin_users_url, notice: 'User was successfully destroyed.'
    end

    private

    def base_scope
      policy_scope(User)
    end

    def set_user
      @user = User.find(params[:id])
      authorize(@user)
    end

    def user_params
      params.require(:user).permit(policy([:admin, @user]).permitted_attributes)
    end
  end
end
