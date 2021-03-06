# frozen_string_literal: true

class VlansController < ApplicationController
  load_and_authorize_resource
  before_action :set_permissions, only: %i[edit update]

  # GET /vlans
  def index
    @vlans = Vlan.accessible_by(current_ability).page params[:page]
  end

  # GET /vlans/1
  def show
    # not used actually
  end

  # GET /vlans/new
  def new
    @vlan = Vlan.new
  end

  # GET /vlans/1/edit
  def edit
    # not used actually
  end

  # POST /vlans
  def create
    @vlan = Vlan.new(vlan_params)

    if @vlan.save
      Permission.create!(
        {
          user_id: current_user.id,
          subject_class: 'Vlan',
          subject_id: @vlan.id,
          action: 'manage'
        }
      )

      redirect_to @vlan, notice: _('Vlan was successfully created.')
    else
      render :new
    end
  end

  # PATCH/PUT /vlans/1
  def update
    if @vlan.update(vlan_params)
      redirect_to @vlan, notice: _('Vlan was successfully updated.')
    else
      render :edit
    end
  end

  # DELETE /vlans/1
  def destroy
    @vlan.destroy
    redirect_to vlans_url, notice: _('Vlan was successfully destroyed.')
  end

  private

  def set_permissions
    @permissions = Permission.where(subject_class: 'Vlan', subject_id: @vlan.id)
  end

  def vlan_params
    params.require(:vlan).permit(:vid, :name, :description)
  end
end
