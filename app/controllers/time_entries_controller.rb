class TimeEntriesController < ApplicationController
  before_action :prepare_scope
  before_action :set_time_entry, only: [:show, :edit, :update, :destroy]

  def index
    user_scope = Thread.current[:time_entries_scope]
    @time_entries = TimeEntry.where(user_id: user_scope).order(created_at: :desc)

    respond_to do |format|
      format.html { render json: @time_entries }
      format.json { render json: @time_entries }
    end
  end

  def show
    respond_to do |format|
      format.html { render json: @time_entry }
      format.json { render json: @time_entry }
    end
  end

  def new
    @time_entry = TimeEntry.new
  end

  def create
    @time_entry = TimeEntry.new(time_entry_params.merge(user_id: current_user.id))
    if @time_entry.save
      respond_to do |format|
        format.html { redirect_to @time_entry }
        format.json { render json: @time_entry, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @time_entry.update(time_entry_params)
      respond_to do |format|
        format.html { redirect_to @time_entry }
        format.json { render json: @time_entry }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to time_entries_path }
      format.json { head :no_content }
    end
  end

  private

  def prepare_scope
    Thread.current[:time_entries_scope] ||= (params[:filter_user_id].presence || current_user&.id)
  end

  def set_time_entry
    @time_entry = TimeEntry.find(params[:id])
  end

  def time_entry_params
    params.require(:time_entry).permit(:project_code, :hours, :notes, :billable)
  end
end
