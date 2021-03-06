class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :home, :show]

  # GET /events
  # GET /events.json

  def index
    # @events = Event.all

    @categories = Category.all

    @filterrific = initialize_filterrific(
    Event,
    params[:filterrific],
    select_options: {
      sorted_by: Event.options_for_sorted_by,
      with_category_id: Category.options_for_select
    },
  ) or return
    if params[:tag]
      @events = @filterrific.find.page(params[:page]).tagged_with(params[:tag])
    else
      @events = @filterrific.find.page(params[:page])
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def home
    # @events = Event.all

    @categories = Category.all
    @last_events = Event.order("created_at desc").limit(5)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = current_user.events.build
    @categories = Category.all.map{|c| [ c.name, c.id ] }

  end

  # GET /events/1/edit
  def edit
    @categories = Category.all.map{|c| [ c.name, c.id ] }

  end

  # POST /events
  # POST /events.json
  def create
    # @event = Event.new(event_params)
    @event = current_user.events.build(event_params)
    @event.category_id = params[:category_id]


    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update

    @event.category_id = params[:category_id]

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def correct_user
      @event = current_user.events.find_by(id: params[:id])
      redirect_to events_path, notice: "Not authorized to edit this pin" if @event.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title,:description, :image, :date_begin, :time_begin, :date_end, :time_end, :tag_list)
    end
end