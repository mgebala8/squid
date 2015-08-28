class MainController < ApplicationController

  before_filter :check_auth, :only => :index

  def index

    if params[:www].nil?
      params[:www] = 'http://wyborcza.pl/0,0.html'
    end

    http = Curl::Easy.perform(params[:www]) do |curl|
      curl.headers["User-Agent"] = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
      curl.verbose = true
    end

    @data = nil;
    require 'uri'

    @body = http.body_str.force_encoding("ISO-8859-2").encode!("UTF-8")
    render html: @body.gsub!(/https?:\/\/[\S]+.html/, request.base_url+'?www=\&').gsub!(/https?:\/\/[\S]+\.pl\/"/, request.base_url+'?www=\&').html_safe

  end

  def login

    #if session[:logged] == true
    #    redirect_to action: 'index'
    #end

    unless params[:password].nil?
      if  params[:password] == 'WyborczaTIP'
        session[:logged] = true;
        redirect_to action: 'index'
      end
    end

  end

  def check_auth
    if session[:logged] != true
        redirect_to action: 'login'
    end
  end

end
