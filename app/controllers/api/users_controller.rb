class API::UsersController < Api::BaseApiController

    before_action :set_user, only: [:show, :edit, :update, :destroy]

    # GET /users or /users.json
    def index
        @users = User.all
    end


    # GET /users/1 or /users/1.json
    def show

    end

    # GET /users/new
    def new
        @user = User.new
        # returns a form
    end

    # GET /users/1/edit 
    def edit
        #returns a html 
    end

    # POST /users or /users.json 
    def create 
        @user = User.new(user_params)

        respond_to do |format|
            if @user.save
                #format.html { redirect_to users_url(@user), notice: "User was successfully created."}
                format.json { render :show, status: :created, location: @user }
            else
                format.html { render :edit, status: :unprocessable_entity}
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /users/1 or /users/1/.json
    def update
        respond_to do |format|
            if @user.update(user_params)
                #format.html { redirect_to user_url(@user), notice: "User was successfully updated."}
                format.json { render :show, status: :ok, location: @user }
            else
                format.html { render :edit, status: :unprocessable_entity}
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /users/1 or /users/1.json
    def destroy
        @user.destroy

        respond_to do |format|
            #format.html { redirect_to users_url, notice: "User was successfully destroyed."}
            format.json { head :no_content }
        end
    end

    private 
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        Rails.logger.debug "params.class => #{params.class}"
        @user = User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def
        params.require(:user).permit(:name, :lastname, :username, :email, :password)
      end
end

# set_article se ejecuta antes de las acciones show, edit, update y destroy. 
# Es útil para reducir la repetición de código, ya que es probable que necesites 
# encontrar un artículo por su ID en todas esas acciones.