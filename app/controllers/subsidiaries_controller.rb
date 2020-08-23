class SubsidiariesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]
  def index
    @subsidiaries = Subsidiary.all
  end
  def show
    @subsidiary = Subsidiary.find(params[:id])
  end
end