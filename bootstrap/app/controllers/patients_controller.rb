class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :update, :destroy, :bmr_calculate, :bmr_history, :bmi]

  # GET /patients
  def index
    scope = Patient.all

    if params[:full_name].present?
      q = params[:full_name].downcase
      scope = scope.where("LOWER(first_name || ' ' || COALESCE(middle_name,'') || ' ' || last_name) LIKE ?", "%#{q}%")
    end

    if params[:gender].present?
      scope = scope.where(gender: params[:gender])
    end

    if params[:start_age].present? || params[:end_age].present?
      today = Date.today
      if params[:start_age].present?
        # birthdate on or before ... ensures age >= start_age
        scope = scope.where("birthday <= ?", today - params[:start_age].to_i.years)
      end
      if params[:end_age].present?
        # birthdate after ... ensures age <= end_age
        scope = scope.where("birthday >= ?", today - params[:end_age].to_i.years)
      end
    end

    limit = (params[:limit] || 20).to_i
    offset = (params[:offset] || 0).to_i

    patients = scope.limit(limit).offset(offset).order(:id)
    render json: patients
  end

  # GET /patients/:id
  def show
    render json: @patient
  end

  # POST /patients
  def create
    patient = Patient.create!(patient_params)
    render json: patient, status: :created
  end

  # PATCH/PUT /patients/:id
  def update
    @patient.update!(patient_params)
    render json: @patient
  end

  # DELETE /patients/:id
  def destroy
    @patient.destroy!
    head :no_content
  end

  # POST /patients/:id/bmr_calculate
  def bmr_calculate
    formula = params[:formula].to_s.downcase
    unless %w[mifflin harris].include?(formula)
      return render json: { error: "formula must be 'mifflin' or 'harris'" }, status: :unprocessable_entity
    end

    value = BmrService.calculate(@patient, formula)
    record = @patient.bmr_records.create!(formula: formula, value: value)

    render json: { patient_id: @patient.id, formula: formula, bmr: value, record_id: record.id }
  end

  # GET /patients/:id/bmr_history
  def bmr_history
    limit = (params[:limit] || 20).to_i
    offset = (params[:offset] || 0).to_i
    render json: @patient.bmr_records.order(created_at: :desc).limit(limit).offset(offset)
  end

  # GET /patients/:id/bmi
  def bmi
    result = ExternalBmiService.fetch(@patient.height, @patient.weight)
    render json: { patient_id: @patient.id }.merge(result)
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :middle_name, :birthday, :gender, :height, :weight, doctor_ids: [])
  end
end
