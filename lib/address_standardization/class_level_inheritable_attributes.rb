# from <http://railstips.org/2008/6/13/a-class-instance-variable-update>
module ClassLevelInheritableAttributes
  def self.included(base)
    base.extend(ClassMethods)    
  end

  module ClassMethods
    def cattr_inheritable(*args)
      @cattr_inheritable_attrs ||= [:cattr_inheritable_attrs]
      @cattr_inheritable_attrs += args
      args.each do |arg|
        class_eval %(
          class << self; attr_accessor :#{arg} end
        )
      end
      @cattr_inheritable_attrs
    end

    def inherited(subclass)
      @cattr_inheritable_attrs.each do |inheritable_attribute|
        instance_var = "@#{inheritable_attribute}" 
        subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
      end
    end
  end
end