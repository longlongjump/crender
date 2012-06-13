module ActionController
  module Rendering

    alias_method :render_orig, :render
    def render_controller(controller_class, options = {:action => :index})
      status, headers, resp =  controller_class.action(options[:action]).call(request.env)
      render_orig :text => resp.body, :status => status
    end

    def controller_options(*args)
      options = args.first
      return options if options.is_a?(Hash) && options[:controller]
      nil
    end

    def render(*args)
      if options = controller_options(*args)
        controller = options.delete(:controller)
        render_controller(controller, options)
      else
        render_orig(*args)
      end
    end

  end
end
