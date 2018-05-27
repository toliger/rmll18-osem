module Rmll
  class RmllController < ApplicationController
    layout "rmll"
    skip_authorization_check

    before_action :set_locale

    after_action :push_headers

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
      puts I18n.default_locale
    end

    def push_headers
      if request.format.html? # only on html pages
        assets = [
          "<#{view_context.asset_path('rmll/stylesheet')}>; rel=preload; as=style",
          "<#{view_context.asset_path('rmll/lib/menu')}>; rel=preload; as=script",
          "<#{view_context.asset_path('rmll/script')}>; rel=preload; as=script",
        ]
        response.headers['Link'] = assets
      end
    end

    def default_url_options
      { locale: I18n.locale }
    end

    def index
      if params[:heading].nil?
        render "rmll/index"
      elsif params[:page].nil?
        render "rmll/#{params[:heading]}"
      elsif params[:sub].nil?
        render "rmll/#{params[:heading]}/#{params[:page]}"
      else
        render "rmll/#{params[:heading]}/#{params[:page]}/#{params[:sub]}"
      end
    end
  end
end
