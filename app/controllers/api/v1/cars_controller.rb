class Api::V1::CarsController < Api::V1::ApiController

  def index
    render json: Car.available, status: 200
  end
  def show
    @car = Car.find(params[:id])
    # return render json: @car if @car
    # render status: :not_found, json: ''
    render json: @car
  end

  def create
    @car = Car.create(car_params)
    @car.save!
    render status: :created, json: @car
  
  rescue ActionController::ParameterMissing
    render status: :precondition_failed, json: 'Parâmetros inválidos'
  end

  private

  def car_params
    params.require(:car)
          .permit(:license_plate, :color, :mileage, :car_model_id, :subsidiary_id)
  end
end 