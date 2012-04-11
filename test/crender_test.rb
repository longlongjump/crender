require 'test/unit'
require "action_controller"
require 'init.rb'
require 'rails'

SharedTestRoutes = ActionDispatch::Routing::RouteSet.new


class RoutedRackApp
  attr_reader :routes

  def initialize(routes, &blk)
    @routes = routes
    @stack = ActionDispatch::MiddlewareStack.new(&blk).build(@routes)
  end

  def call(env)
    @stack.call(env)
  end
end

class ActionDispatch::IntegrationTest < ActiveSupport::TestCase
  setup do
    @routes = SharedTestRoutes
  end

  def self.build_app(routes = nil)
    RoutedRackApp.new(routes || ActionDispatch::Routing::RouteSet.new) do |middleware|
      middleware.use "ActionDispatch::DebugExceptions"
      middleware.use "ActionDispatch::Callbacks"
      middleware.use "ActionDispatch::ParamsParser"
      middleware.use "ActionDispatch::Cookies"
      middleware.use "ActionDispatch::Flash"
      middleware.use "ActionDispatch::Head"
      yield(middleware) if block_given?
    end
  end

  self.app = build_app(SharedTestRoutes)
end



class CallersController < ActionController::Base
  include SharedTestRoutes.url_helpers
  def calling_from_controller
    render :controller => CalleeController, :action => 'being_called'
  end

  def render_text
    render :text => "CalleeController", :status => 200
  end
end


class CalleeController < ActionController::Base
  
  include SharedTestRoutes.url_helpers
  def being_called
    render :text => "CalleeController", :status => 200
  end

end

class RenderTest < ActionDispatch::IntegrationTest
    

  def test_calling_from_action
    get "callers/calling_from_controller"
    assert_equal "CalleeController", @response.body
  end

  def test_render
    get "callers/render_text"
    assert_equal "CalleeController", @response.body
  end


  def setup
    @routes = SharedTestRoutes
    @routes.draw do
      match ':controller(/:action)'
    end


  end

end




