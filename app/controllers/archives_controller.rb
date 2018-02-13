class ArchivesController < ApplicationController
  before_action :set_archive, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :admin_only

  # GET /archives
  # GET /archives.json
  def index
    @archives = Archive.all
  end

  # GET /archives/1
  # GET /archives/1.json
  def show
  end

  # GET /archives/new
  def new
    @archive = Archive.new
  end

  # GET /archives/1/edit
  def edit
  end

  # POST /archives
  # POST /archives.json
  def create
    @archive = Archive.new(archive_params)

    respond_to do |format|
      if @archive.save
        format.html { redirect_to @archive, notice: 'Archive was successfully created.' }
        format.json { render :show, status: :created, location: @archive }
      else
        format.html { render :new }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /archives/1
  # PATCH/PUT /archives/1.json
  def update
    respond_to do |format|
      if @archive.update(archive_params)
        format.html { redirect_to @archive, notice: 'Archive was successfully updated.' }
        format.json { render :show, status: :ok, location: @archive }
      else
        format.html { render :edit }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archives/1
  # DELETE /archives/1.json
  def destroy
    @archive.destroy
    respond_to do |format|
      format.html { redirect_to archives_url, notice: 'Archive was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def make_articles
    @file = Archive.find(params[:id])

    File.open("#{Dir.pwd}/public#{@file.archive.url}", 'r') do |fh|
      while(line = fh.gets) != nil

        if line.include?("AA..")
          @article = Article.new
          @article.content = ""
          @article.legislation = Legislation.find_by_id(@file.kind)

          while(line = fh.gets) != nil
            break if line.include?("..AA")
            @article.content = @article.content + "\n" + line
          end

          @article.save
        end

      end
    end
    redirect_to articles_path
  end

  def make_comments
    @file = Archive.find(params[:id])
    
    File.open("#{Dir.pwd}/public#{@file.archive.url}", 'r') do |fh|      
      @prev = ""      
      @articles = Article.where(:legislation => @file.kind)
      @a = @articles.first.id

      while(line = fh.gets) != nil
        if line[0..3] == ("Art.") or @prev[0..3] == ("Art.")
          @comment = Comment.new
          @comment.content = ""
          @comment.article = Article.find_by_id(@a)
          @content = ""
          while(line = fh.gets) != nil
            @prev = line
            break if line[0..3] == ("Art.")
            @content = @content + "\n" + line
          end
          @comment.save
          File.write("#{Dir.pwd}/public/comments/article_#{@a}_comment#{@comment.id}.txt", @content)
          @a = @a + 1          
          break if @a > @articles.last.id
        end
      end
    end

    redirect_to articles_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_archive
      @archive = Archive.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def archive_params
      params.require(:archive).permit(:archive, :kind, :is_comment)
    end
end
