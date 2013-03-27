module Injection::Helper::Application
  module ClassMethods
    
  end
  
  module InstanceMethods
    def user_signed_in?
      !current_user.nil?
    end
    
    def date_format date, include_time = false, include_am_pm = false
      return nil if date.blank?
      format = date.year == Time.now.year ? "%d %b" : "%d %b %Y"
      format += ", %H:%M" if include_time
      format += " %p" if include_am_pm
      date.strftime(format)
    end
    
    def link_to_add_fields(name, f, association)
      new_object = f.object.send(association).klass.new
      id = new_object.object_id
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render(association.to_s.singularize + "_fields", f: builder)
      end
      link_to(name, '#', class: "add_fields btn btn-primary btn-mini float-left", data: {id: id, fields: fields.gsub("\n", "")})
    end
    
    
    def inject_options options = {}, tag = nil
      opts = options.map{|key, value| "#{key.to_s} = \"#{value.to_s}\""}.join(" ")
      return opts if tag.nil?
      "<#{tag} #{opts}>#{yield}</#{tag}>".html_safe
    end
    
    
    def link_sortable th_content, key
      "#{link_to(th_content, params.merge({:sort => key.to_s}))}".html_safe
    end
    
    def link_sortable_key key
      link_sortable(key.to_s.humanize, key.to_s)
    end
    
    def th_sortable th_content, key, options = {}
      #"<th>#{link_sortable(th_content, key.to_s)}</th>".html_safe
      inject_options(options, "th"){ link_sortable(th_content, key.to_s)}
    end
    
    def th_sortable_key key, options = {}
      th_sortable(key.to_s.humanize, key.to_s, options)
    end
    
    def ths_sortable_keys keys, options = {}
      keys.map{ |key| th_sortable(key.to_s.humanize, key.to_s, options) }.join("\n").html_safe
    end
    
    def label_yes_no input
      klass = input ? "success" : "warning"
      text = input ? "Yes" : "No"
      "<span class='label label-#{klass}'>#{text}</span>".html_safe
    end
    
    def button_yes_no input, url = "#", options = {}
      bg_klass = input ? "success" : "warning"
      text = input ? "Yes" : "No"
      opt_klass = "#{options[:class]} #{options["class"]}".strip
      klass = "btn btn-#{bg_klass} #{opt_klass}".strip
      options.delete("class")
      options.delete(:class)
      extra = options.map{ |key, value| "#{key.to_s} = \"#{value}\""}.join("").strip
      #"<a href = '#{url}' class = \"#{klass}\" #{extra}>#{text}</a>".html_safe
      link_to text, url, { :class => klass }.merge(options)
    end
    
    def javascript_toggle klass, attributes = [], method = "post"
      json = attributes.map{|att| "#{att.to_s} : $(this).data(\"#{att.to_s}\")"}.join(", ")
      #json = "#{json}, _method: \"delete\"" if method.to_s == "delete"
      script = <<-section_js
          <script type = "text/javascript">
            $(function(){
              $(".#{klass}").live("click", function(e){
                e.preventDefault();
                var url = $(this).attr("href");
                var triggerer = $(this);
                triggerer.attr("disabled", "disabled");
                var loading = #{loading_dots("triggerer")}();

                $.#{method.to_s}(url, {#{json}}, function(data){
                  clearInterval(loading);
                  triggerer.removeAttr("disabled");
                  if(data.error){
                    triggerer.html("Err");
                    triggerer.removeClass("btn-success");
                    triggerer.removeClass("btn-warning");
                    triggerer.addClass("btn-danger");
                    return;
                  }
                    
                  if(data.result){
                    triggerer.html("Yes");
                    triggerer.removeClass("btn-warning");
                    triggerer.addClass("btn-success");
                  }
                  else{
                    triggerer.html("No");
                    triggerer.removeClass("btn-success");
                    triggerer.addClass("btn-warning");
                  }
                }, "json");
              });
            });
          </script>        
        section_js
      script.html_safe
    end
    
    
    def loading_dots(triggerer, duration = 500, numDot = 4)
      script = <<-section_js
        function(){
          var dotNumber = 0;
          return setInterval(function(){
            dotNumber = (dotNumber) % #{numDot} + 1;
            str_dot = "";
            for(var i = 1; i <= dotNumber; i++) str_dot += ".";
            $(#{triggerer}).html(str_dot);
          }, #{duration});
        }
      section_js
    end

    def active_menu_item controllers = [], active_class = "active"
      controllers.include?(params[:controller]) ? active_class : ""
    end

    def on_off_item controllers = []
      controllers.include?(params[:controller]) ? "on" : "off"
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end