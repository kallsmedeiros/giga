class UsersController < ApplicationController
  require 'net/http'
  require 'json'
  require 'open-uri'
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.page(params[:page]).per(15)
  end

  def search
    @users = User.where("name LIKE ? OR email LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%").page(params[:page]).per(15)
    # name: params[:search]).or(email: params[:search]).page(params[:page]).per(15)
    # @users = User.all.page(params[:page]).per(15)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import_json
    uri      = URI("https://randomuser.me/api/?results=30&inc=gender,name,email,picture&nat=br&seed=giga")
    response = Net::HTTP.get(uri)
    json_users = JSON.parse(response)
    json_users.each do |r|
      r[1].each do |u|
        user_new = User.new
        u.each do |user|
          if user[0] == "gender"
            user_new.gender = user[1]
          elsif user[0] == "name"
            name = ''
            user[1].each do |k, v|
               name << v if not k == 'title'
               name << " "
            end
            user_new.name = name
          elsif user[0] == "email"
            user_new.email = user[1]
          elsif user[0] == "picture"
            url = ''
            user[1].each do |k, v|
              url = v if k == 'large'
            end
            user_new.remote_picture_url = url
          else
          end
        end
        user_new.save! unless user_new.gender.nil?
      end
    end
    redirect_to users_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :gender, :email, :picture)
    end
end
