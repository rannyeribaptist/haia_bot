class AdminController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @legislations = Legislation.all    
    @archives = Archive.all
    @users = User.all

    if params[:filterrific].present?
      params[:filterrific][:search_query].each_char do |a|
        if not a =~ /[0-9]/
          params[:filterrific][:search_query].delete!(a)
        end
      end
    end
    @filterrific = initialize_filterrific(
      Article,
      params[:filterrific],
      select_options: {
        legislation: Legislation.all.collect {|a| [a.name, a.id]}
      }      
    ) or return    
    if @filterrific.find.length > 1
      @article = ""
    else
      @article = @filterrific.find
    end
  end
end
