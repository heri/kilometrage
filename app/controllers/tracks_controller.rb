






class TracksController < ApplicationController
  before_action :set_track, only: [:update, :destroy]

  helper_method :rental

  # GET /tracks/new
  def new
    rental
    @track = Track.new
  end

  # POST /tracks
  # POST /tracks.json
  def create
    rental
    @track = Track.new(track_params)
    @track.rental_id = @rental.id

    respond_to do |format|
      if @track.save

        # open CSV file with latitude, longitude coordinates
        file = CSV.read(@track.recording.path, {:col_sep => ";", headers: [nil, 'lat', 'lng'], converters: :numeric})
        @track.calculate_mileage_from_recording(file) if file

        format.html { redirect_to rental_path(@rental), notice: 'Track was successfully created.' }
        format.json { render :show, status: :created, location: @track }
      else
        format.html {
          render :new
        }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    rental
    @track.destroy
    respond_to do |format|
      format.html { redirect_to rental_path(@rental), notice: 'Track was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_params
      params.require(:track).permit(:recording)
    end

    def rental
      @rental ||= params[:rental_id] ? Rental.find(params[:rental_id]) : nil
    end
end
