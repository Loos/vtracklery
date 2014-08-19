class Api::V1::WorkTimesController < Api::V1::BaseController
  before_action :set_work_time, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/work_times.json
  def index
    @work_times = WorkTime.all
  end

  # GET /api/v1/work_times/1.json
  def show
  end

  # POST /api/v1/work_times.json
  def create
    @work_time = WorkTime.new(work_time_params)

    respond_to do |format|
      format.json do
        if @work_time.save
          render action: 'show', status: :created, location: @work_time
        else
          render json: @work_time.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /api/v1/work_times/1.json
  def update
    respond_to do |format|
      format.json do
        if @work_time.update(work_time_params) then head :no_content
        else
          render json: @work_time.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /api/v1/work_times/1.json
  def destroy
    @work_time.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_time
      @work_time = WorkTime.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_time_params
      params.require(:work_time).permit(:start_at, :end_at, :created_at, :updated_at)
    end
end
