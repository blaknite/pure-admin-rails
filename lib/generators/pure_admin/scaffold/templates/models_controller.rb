##
# Controller for {ModelClassName}
class ModelClassNamePluralController < ApplicationController
  respond_to :html

  def index
    @title = 'ModelClassTitlePlural'
    @model_instance_collection = apply_scopes(@model_instance_collection)

    respond_with(@model_instance_collection) do |format|
      format.html do
        @model_instance_collection = @model_instance_collection.page(params[:page])
        render partial: 'table' if request.xhr?
      end
    end
  end

  def show
    @title = @model_instance_singular
  end

  def new
    @title = 'New ModelClassNameReadable'
  end

  def create
    respond_to do |format|
      if @model_instance_singular.save
        format.html do
          redirect_to @model_instance_singular, notice: 'ModelClassNameReadable was successfully created.'
        end
      else
        format.html do
          @title = 'New ModelClassNameReadable'
          render action: :new
        end
      end
    end
  end

  def edit
    @title = "Edit #{@model_instance_singular}"
  end

  def update
    respond_to do |format|
      if @model_instance_singular.update(model_instance_singular_params)
        format.html do
          redirect_to @model_instance_singular, notice: 'ModelClassNameReadable was successfully updated.'
        end
      else
        format.html do
          @title = "Edit #{@model_instance_singular}"
          render action: :edit
        end
      end
    end
  end

  def destroy
    # Place your destroy logic here
  end

  private

    def model_instance_singular_params
      params.require(:model_instance_singular).permit()
    end
end
