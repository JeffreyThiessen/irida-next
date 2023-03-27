# frozen_string_literal: true

module Projects
  # Controller actions for Samples
  class SamplesController < ApplicationController
    before_action :sample, only: %i[show edit update destroy]
    before_action :project, only: %i[index create]

    def index
      @samples = Sample.where(project_id: @project.id)
    end

    def show
      return unless @sample.nil?

      render status: :unprocessable_entity, json: {
        message: t('.error')
      }
    end

    def new
      @sample = Sample.new
    end

    def edit; end

    def create
      @sample = Sample.new(sample_params.merge(project_id: @project.id))

      respond_to do |format|
        if @sample.save
          flash[:success] = t('.success')
          format.html { redirect_to namespace_project_sample_path(id: @sample.id) }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @sample.update(sample_params)
          flash[:success] = t('.success')
          format.html { redirect_to namespace_project_sample_path(id: @sample.id) }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      if @sample.nil?
        render status: :unprocessable_entity, json: {
          message: t('.error')
        }
      else
        @sample.destroy
        flash[:success] = t('.success', sample_name: @sample.name)
        redirect_to namespace_project_samples_path
      end
    end

    private

    def sample
      @sample ||= Sample.find_by(id: params[:id], project_id: project.id)
    end

    def sample_params
      params.require(:sample).permit(:name, :description)
    end

    def project
      path = [params[:namespace_id], params[:project_id]].join('/')
      @project ||= Namespaces::ProjectNamespace.find_by_full_path(path).project # rubocop:disable Rails/DynamicFindBy
    end
  end
end