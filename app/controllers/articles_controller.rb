class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :authenticate_user!  

  # GET /articles
  # GET /articles.json
  def index
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

    if not @article.empty?
      if @article.first.comments.present?
        @comments = []
        @authors = []
        @article.first.comments.each_with_index do |c, i|
          @comments[i] = File.read("#{Dir.pwd}/public/comments/#{@article.first.id}#{c.id}.txt")
          @authors[i] = c.author
        end
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    if @article.comments.present?
      @comments = []
      @authors = []
      @article.comments.each_with_index do |c, i|
        @comments[i] = File.read("#{Dir.pwd}/public/comments/#{@article.id}#{c.id}.txt")
        @authors[i] = c.author
      end
    end    
  end

  def api_request
    params[:number].each_char do |a|
      if not a =~ /[0-9]/
        params[:number].delete!(a)
      end
    end
    @article = Article.where(:number => params[:number]).where(:legislation_id => params[:legislation]).first
    if @article.comments.present?
      @comments = []
      @authors = []
      @article.comments.each_with_index do |c, i|
        @comments[i] = File.read("#{Dir.pwd}/public/comments/#{@article.id}#{c.id}.txt")
        @authors[i] = c.author
      end
    end
    render :json => {:article => @article.content, :comments => @comments, :authors => @authors, number: @article.number}
  end

  # GET /articles/new
  def new
    @article = Article.new
    @article.build_comments
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create    
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_path_urlarticle, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to admin_path_url, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.where(:number => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:content, :legislation_id, :comments_attributes => [:content])
    end
end
