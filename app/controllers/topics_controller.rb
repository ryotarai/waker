class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy, :mailgun, :mackerel, :nagios]
  skip_before_action :login_required, only: [:mailgun, :mackerel, :nagios]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /topics/1/mailgun
  def mailgun
    unless @topic.enabled
      Rails.logger.info "Incident creation is skipped because the topic is disabled."
      render json: {}, status: 200
      return
    end

    if @topic.in_maintenance?
      Rails.logger.info "Incident creation is skipped because the topic is in maintenance."
      render json: {}, status: 200
      return
    end

    # http://documentation.mailgun.com/user_manual.html#routes
    @topic.incidents.create!(
      subject: params[:subject],
      description: params['body-plain'],
    )

    render json: {}, status: 200
  end

  def mackerel
    # unless @topic.enabled
    #   Rails.logger.info "Incident creation is skipped because the topic is disabled."
    #   render json: {}, status: 200
    #   return
    # end
    #
    # if @topic.in_maintenance?
    #   Rails.logger.info "Incident creation is skipped because the topic is in maintenance."
    #   render json: {}, status: 200
    #   return
    # end

    # https://mackerel.io/ja/docs/entry/howto/alerts/webhook
    @topic.incidents.create!(
      subject: params['alert']['monitorName'] + ': ' + params['host']['name'] + ': '+ params['alert']['monitorName'],
      description: params['alert']['url'],
    )

    render json: {}, status: 200
  end

  def nagios
    # unless @topic.enabled
    #   Rails.logger.info "Incident creation is skipped because the topic is disabled."
    #   render json: {}, status: 200
    #   return
    # end
    #
    # if @topic.in_maintenance?
    #   Rails.logger.info "Incident creation is skipped because the topic is in maintenance."
    #   render json: {}, status: 200
    #   return
    # end

    # https://mackerel.io/ja/docs/entry/howto/alerts/webhook
    @topic.incidents.create!(
      subject: params['alert']['monitorName'] + ': ' + params['host']['name'] + ': '+ params['alert']['monitorName'],
      description: params['alert']['url'],
    )

    render json: {}, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:name, :kind, :escalation_series_id, :enabled)
    end
end
