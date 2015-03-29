class RmedialSettingsController < ApplicationController
  layout 'media'
  
  # GET /rmedial_settings
  # GET /rmedial_settings.xml
  def index
    @rmedial_settings = RmedialSetting.default
    @last_import_errors = LastImportError.find(:all)
    @media_paths = MediaPath.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rmedial_settings }
    end
  end

  


  # GET /rmedial_settings/1/edit
  def edit
    @rmedial_setting = RmedialSetting.find(params[:id])
  end



  # PUT /rmedial_settings/1
  # PUT /rmedial_settings/1.xml
  def update
    @rmedial_setting = RmedialSetting.find(params[:id])

    respond_to do |format|
      if @rmedial_setting.update_attributes(params[:rmedial_setting])
        flash[:notice] = 'RmedialSetting was successfully updated.'
        format.html { redirect_to(:action=>:index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rmedial_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  def symbol_url
    
  end
end
