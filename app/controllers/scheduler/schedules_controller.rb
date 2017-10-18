class Scheduler::SchedulesController < ApplicationController
  #before_action :set_schedule, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  
  def index
    
    @user_id = params[:user_id]
  
    if current_user.roles.first.name == 'developer'
      @schedules = Schedule.where(user_id: current_user.id).first
    else
      @schedules = Schedule.where(user_id: params[:user_id]).first
    end
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
  end

  # GET /schedules/new
  def new
    
    @user_id = params[:user_id]
    @schedule = Schedule.new

  end

  # GET /schedules/1/edit
  def edit
    @date = params[:date]
    @user_id = params[:user_id]
    @schedule = Schedule.find(params[:id])

  end

  # POST /schedules
  # POST /schedules.json
  def create
    
    params[:days] = params[:days].to_json
    params[:schedule][:days] = params[:days]
    @schedule = Schedule.new(schedule_params)

    respond_to do |format|
      if @schedule.save
        @user = User.find(@schedule.user_id)
        ScheduleMailer.create_schedule(@schedule, @user).deliver_now
        format.html { redirect_to scheduler_schedules_path(user_id: @user.id), notice: 'Schedule was successfully created.' }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  def schedule_change_requests
    @array = []
    @schedule = Schedule.find(params[:id])
    schedule_days = Schedule.find(params[:id]).days
    schedule_days = JSON.parse schedule_days
    schedule_days.each do |n|
      if n[1]["changerequest"].present? and n[1]["changerequest"] == "true"
        @array << n
      end
    end
  end


  def approve_request
  
    @schedule = Schedule.find(params[:id])
    days = JSON.parse @schedule.days
    schedule_change_date = params[:date][0]
    puts schedule_change_date
    days[schedule_change_date]["changerequest"] = "approved"
    days = days.to_json
    @schedule.days = days
    @schedule.save!
     ScheduleMailer.schedule_request_accepted(@schedule.user).deliver_now
    redirect_to scheduler_schedules_path(user_id: @schedule.user.id)

  end

  def reject_request
    @schedule = Schedule.find(params[:id])
    days = JSON.parse @schedule.days
    schedule_change_date = params[:date][0]
    days[schedule_change_date]["changerequest"] = "rejected"
    days = days.to_json
    @schedule.days = days
    @schedule.save!
     ScheduleMailer.schedule_request_rejected(@schedule.user).deliver_now
    redirect_to scheduler_schedules_path(user_id: @schedule.user.id)

  end



  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update

    key = ''
    days_temp = params[:days]
    days_temp.each do |k|
      key = k
    end
    days_db = JSON.parse @schedule.days
    
    if days_db[key].present?
        days_db[key]["changerequest"] = "true"
        days_db = days_db.to_json
        @schedule.days = days_db
        @schedule.save!
        
    else

      update_days = params[:days].to_json

      schedule_days_length = @schedule.days.length
      @schedule.days = @schedule.days[0..schedule_days_length-2]
      update_days_length = update_days.length
      update_days = update_days[1..update_days_length]
      @schedule.days << "," << update_days
    end

    respond_to do |format|
      if @schedule.update(schedule_params)
        admin = User.with_role :admin
        ScheduleMailer.schedule_change_request(admin,update_days, @schedule.user).deliver_now
        format.html { redirect_to scheduler_schedules_path(user_id: @schedule.user.id), notice: 'Schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to scheduler_schedules_path(user_id: @user.id), notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:user_id,:days, :repeat_to)
    end
end
