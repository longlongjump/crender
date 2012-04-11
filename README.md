# Summary
Substitution for render_components using action controller middleware

## Installing
Add to your Gemfile
    gem 'crender', :git => 'git@github.com:nerohellier/crender.git', :branch => '0.0.1'

## Examples
    def index
      render :controller => YourAwesomeController, :action => 'index'
    end

