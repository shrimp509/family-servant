class HabitTracing::HabitController < ApplicationController

  before_action :setup_user, only: [:create_habit, :create_record]

  def new_habit
    @line_user_id = params[:line_user_id]
  end

  def new_record
    @topic_id = params[:topic_id]
    @line_user_id = params[:line_user_id]
  end

  def success; end

  def create_habit
    binding.pry
    Topic.create(title: params[:habit_title], user_id: @user.id) if @user.present?
    redirect_to action: 'success'
  end

  def create_record
    Record.create(user_id: @user.id, topic_id: params[:topic_id], remark: params[:record_remark]) if @user.present?
    redirect_to action: 'success'
  end

  private
  def setup_user
    @user = User.find_by(line_user_id: params[:line_user_id])
  end
end
