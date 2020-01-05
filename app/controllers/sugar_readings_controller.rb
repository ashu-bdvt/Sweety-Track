class SugarReadingsController < ApplicationController
  before_action :set_sugar_reading, only: [:show, :edit, :update, :destroy]

  # GET /sugar_readings
  # GET /sugar_readings.json
  def index
    #For patient type, display all his/her records
    if current_user.type == "Patient"
      @sugar_readings = SugarReading.where(user_id: current_user.id)
      #For dorcto, display all records from all users
    else
      @sugar_readings = SugarReading.all
    end
    @current_user = current_user
  end

  # GET /sugar_readings/1
  # GET /sugar_readings/1.json
  def show
  end

  # GET /sugar_readings/new
  def new
    @sugar_reading = SugarReading.new()
  end

  # GET /sugar_readings/1/edit
  def edit
  end

  # POST /sugar_readings
  # POST /sugar_readings.json
  def create
  @sugar_reading = SugarReading.new(sugar_reading_params)
  @sugar_reading.user = current_user
  authorize @sugar_reading
    respond_to do |format|
      if @sugar_reading.save
        format.html { redirect_to @sugar_reading, notice: 'Sugar reading was successfully created.' }
        format.json { render :show, status: :created, location: @sugar_reading }
      else
        format.html { render :new }
        format.json { render json: @sugar_reading.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sugar_readings/1
  # PATCH/PUT /sugar_readings/1.json
  def update
    autorize @sugar_reading
    respond_to do |format|
      if @sugar_reading.update(sugar_reading_params)
        format.html { redirect_to @sugar_reading, notice: 'Sugar reading was successfully updated.' }
        format.json { render :show, status: :ok, location: @sugar_reading }
      else
        format.html { render :edit }
        format.json { render json: @sugar_reading.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sugar_readings/1
  # DELETE /sugar_readings/1.json
  def destroy
    authorize @sugar_reading
    @sugar_reading.destroy
    respond_to do |format|
      format.html { redirect_to sugar_readings_url, notice: 'Sugar reading was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sugar_reading
      @sugar_reading = SugarReading.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sugar_reading_params
      params.require(:sugar_reading).permit(:reading_date, :glucose_level)
    end
end
