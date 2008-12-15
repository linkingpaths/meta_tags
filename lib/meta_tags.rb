module LinkingPaths
  module MetaTags
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods

      def meta(tags = nil)
        
        include LinkingPaths::MetaTags::InstanceMethods

        # Default any subclasses meta tags to that of the parent
        @meta_data ||= self.superclass.respond_to?(:meta) ? self.superclass.meta.clone : {}
        manage_meta @meta_data, tags
      end
      
      def manage_meta(meta, tags)
        if tags.is_a? Hash
          meta.merge!(tags) 
        elsif tags.is_a? Symbol
          return meta[tags]
        end
        meta
      end
      
    end
    
    module InstanceMethods
      def meta(tags = nil)
        @meta_data ||= self.class.meta.clone
        self.class.manage_meta @meta_data, tags
      end
    end
    
    module Helpers
      def meta_tag(tag)
        meta_html(tag, @meta_data[tag])
      end
      def title_tag
        title = @meta_data[:title]
        title ? %{<title>#{title}</title>} : ''
      end
      def meta_tags
        markup = []
        @meta_data.each{|name,content|
          markup << meta_html(name, content)
        }
        markup
      end

      protected
      
      def meta_html(name, content)
        %{<meta name="#{name}" content="#{content}" />}
      end
    end
    
  end

end

ActionController::Base.send :include, LinkingPaths::MetaTags
ActionView::Base.send :include, LinkingPaths::MetaTags::Helpers