module Injection::Controller::Application
  module ClassMethods
    def load_application_class_methods
      helper_method :current_user, :domain_address

      rescue_from Injection::Error::DefinedError::AlreadyLoginError do 
        render "users/already_logged_in"
      end

      rescue_from Injection::Error::DefinedError::LoginRequired do
        redirect_to login_url
      end

      rescue_from Injection::Error::DefinedError::WrongSection do
        render "users/wrong_section"
      end
      
      rescue_from Injection::Error::DefinedError::EntityNotFound do
        render "shared/page_not_found"
      end
    end
  end
  
  module InstanceMethods
    private  
    def current_user
      @userx ||= User.find_by_id(session[:user_id]) if session[:user_id]
      if @userx.nil? || !@userx.activated || @userx.locked
        session[:user_id] = nil
        @userx = nil
        return nil
      end
      @userx
    end

    def authenticate_user!
      redirect_to login_url if current_user.nil?
    end


    def allow_non_login_only
      raise Injection::Error::DefinedError::AlreadyLoginError unless current_user.nil?
    end
    
    def get_entity entity
      raise Injection::Error::DefinedError::EntityNotFound if entity.nil?
      entity
    end

    def get_entity_auto_id klass
      get_entity klass.find_by_id params[:id]
    end
    
    def toggle_field ar_object, field = nil
      field ||= params[:field].to_s
      return { error: "Item doens't exist"} if ar_object.nil?
      return { error: "'#{field}' doens't exist"} unless ar_object.has_attribute?(field)
      ar_object.update_attribute(field, !ar_object[field])
      return {result: ar_object[field]}
    end

    def domain_address
      "#{request.scheme}://#{request.host_with_port}"
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.load_application_class_methods
  end

end