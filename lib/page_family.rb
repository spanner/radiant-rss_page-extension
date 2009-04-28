module PageFamily

  def self.included(base)
    base.class_eval {
      include InstanceMethods
    }
  end
  
  module InstanceMethods     
        
    # not so clever, this. we make two passes so as to be able to apply the usual find and sort options
    # one expensively recursive dive to gather all the ids and then a database fetch of everything at once
    # the only way to do it better would be to change the whole tree paradigm, so hey. we have a cache.
    
    def descendants(options={})
      descendants = whole_family_except_me
      if descendants.empty?
        []
      else
        options[:conditions] = ["(virtual = ?) AND (status_id = ?) AND id IN (#{descendants.map{'?'}.join(',')})", false, Status['published'].id, descendants].flatten;
        logger.warn "!!! finding descendants with options: #{options.inspect}"
        Page.find(:all, options)
      end
    end

    def whole_family
      family = [self.id]
      children.each { |child| family += child.whole_family }
      family
    end

    def whole_family_except_me
      family = []
      children.each { |child| family += child.whole_family }
      family
    end

  end
end

