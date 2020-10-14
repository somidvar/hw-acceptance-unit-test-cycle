require 'simplecov'
SimpleCov.start 'rails'
require 'rails_helper'

describe MoviesController do
  before(:each) do
    @movie1 = FactoryBot.create(:movie, id: 1, title: "Test1", rating: "R", description: "", release_date: "2000", director: "sample1")
    @movie2 = FactoryBot.create(:movie, id: 2, title: "Test2", rating: "G", description: "", release_date: "2001", director: "sample2")
    @movie3 = FactoryBot.create(:movie, id: 3, title: "Test3", rating: "G", description: "", release_date: "2001", director: "sample1")
    @movie4 = FactoryBot.create(:movie, id: 4, title: "Test4", rating: "PG", description: "", release_date: "2003")
  end

  describe 'preexisting method test in before(:each)' do
    it 'should call find model method' do
      Movie.should_receive(:find).with('1')
      get :show, :id => '1'
    end

    it 'should render page correctoy' do
      get :index
      response.should render_template :index
    end

    it 'should redirect to appropriate url' do
      get :index, 
          {},    
          {ratings: {G: 'G', PG: 'PG'}}
      response.should redirect_to :ratings => {G: 'G', PG: 'PG'}
    end

    it 'should create movie and redirect' do
      post :create,
           {:movie => { :title => "Test5", :description => "blah", :director => "sample4", :rating => "PG", :release_date =>"2004"}}
      response.should redirect_to movies_path
      expect(flash[:notice]).to be_present

    end
    it 'should render two movies' do
      get :index
      response.should render_template :index
    end

    it 'should update render edit view' do
      Movie.should_receive(:find).with('1')
      get :edit,
          {id: '1'}

    end

    it 'should update data correctly' do
      Movie.stub(:find).and_return(@movie1)
      put :update,
          :id => @movie1[:id],
          :movie => {title: "Test6", rating: "R", description: "blah2", release_date: "2005", director: "none"}
      expect(flash[:notice]).to be_present
    end
  end

  describe 'director methods test in before(:each)' do
    it 'should call appropriate model method' do
      Movie.should_receive(:similar_movies).with(@movie3[:id], {'director' => @movie3[:director]})
      get :similar, :id => @movie3[:id], :based_on => 'director'
    end
  end
end