class DoctorsController < ApplicationController
  before_action :set_doctor, only: [:show, :update, :destroy]

  def index
    limit = (params[:limit] || 20).to_i
    offset = (params[:offset] || 0).to_i
    render json: Doctor.order(:id).limit(limit).offset(offset)
  end

  def show
    render json: @doctor
  end

  def create
    doctor = Doctor.create!(doctor_params)
    render json: doctor, status: :created
  end

  def update
    @doctor.update!(doctor_params)
    render json: @doctor
  end

  def destroy
    @doctor.destroy!
    head :no_content
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :middle_name)
  end
end
