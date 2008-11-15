class CaptchaOnIknowDemosController < ApplicationController
  iknow_captcha_check :only => ['create', 'update']

  # GET /captcha_on_iknow_demos
  # GET /captcha_on_iknow_demos.xml
  def index
    @captcha_on_iknow_demos = CaptchaOnIknowDemo.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @captcha_on_iknow_demos }
    end
  end

  # GET /captcha_on_iknow_demos/1
  # GET /captcha_on_iknow_demos/1.xml
  def show
    @captcha_on_iknow_demo = CaptchaOnIknowDemo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @captcha_on_iknow_demo }
    end
  end

  # GET /captcha_on_iknow_demos/new
  # GET /captcha_on_iknow_demos/new.xml
  def new
    @captcha_on_iknow_demo = CaptchaOnIknowDemo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @captcha_on_iknow_demo }
    end
  end

  # GET /captcha_on_iknow_demos/1/edit
  def edit
    @captcha_on_iknow_demo = CaptchaOnIknowDemo.find(params[:id])
  end

  # POST /captcha_on_iknow_demos
  # POST /captcha_on_iknow_demos.xml
  def create
    @captcha_on_iknow_demo = CaptchaOnIknowDemo.new(params[:captcha_on_iknow_demo])

    respond_to do |format|
      #if @captcha_on_iknow_demo.save
        flash[:notice] = 'CaptchaOnIknowDemo was successfully created.'
        format.html { redirect_to(@captcha_on_iknow_demo) }
        format.xml  { render :xml => @captcha_on_iknow_demo, :status => :created, :location => @captcha_on_iknow_demo }
      #else
      #  format.html { render :action => "new" }
      #  format.xml  { render :xml => @captcha_on_iknow_demo.errors, :status => :unprocessable_entity }
      #end
    end
  end

  # PUT /captcha_on_iknow_demos/1
  # PUT /captcha_on_iknow_demos/1.xml
  def update
    @captcha_on_iknow_demo = CaptchaOnIknowDemo.find(params[:id])

    respond_to do |format|
      #if @captcha_on_iknow_demo.update_attributes(params[:captcha_on_iknow_demo])
        flash[:notice] = 'CaptchaOnIknowDemo was successfully updated.'
        format.html { redirect_to(@captcha_on_iknow_demo) }
        format.xml  { head :ok }
      #else
      #  format.html { render :action => "edit" }
      #  format.xml  { render :xml => @captcha_on_iknow_demo.errors, :status => :unprocessable_entity }
      #end
    end
  end

  # DELETE /captcha_on_iknow_demos/1
  # DELETE /captcha_on_iknow_demos/1.xml
  def destroy
    @captcha_on_iknow_demo = CaptchaOnIknowDemo.find(params[:id])
    #@captcha_on_iknow_demo.destroy

    respond_to do |format|
      format.html { redirect_to(captcha_on_iknow_demos_url) }
      format.xml  { head :ok }
    end
  end
end
