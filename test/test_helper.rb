require 'rubygems'
gem 'mcmire-context'
require 'context'
gem 'mcmire-matchy'
require 'matchy'

module Context
  class SharedBehavior < Module
    # Fix this so that sharing a module twice within two sub-contexts
    # doesn't fail with something like "'test: blah blah' is already defined"
    def included(arg) # :nodoc:
      arg.instance_eval(&@_behavior)
    end
  end
end

class << Test::Unit::TestCase
  # Modify this so that the constant is set within the current context (and sub-contexts)
  def shared(name, &block)
    case name.class.name
    when "String"
      name = name.to_module_name
    when "Symbol"
      name = name.to_s.to_module_name
    else
      raise ArgumentError, "Provide a String or Symbol as the name of the shared behavior group"
    end
    const_set(name, Context::SharedBehavior.create_from_behavior(block))
  end
  %w(shared_behavior share_as share_behavior_as shared_examples_for).each {|m| alias_method m, :shared}
  
  # Modify this so that we look in the current context (and any super-contexts) for the module
  def use(shared_name)
    case shared_name.class.name
    when "Context::SharedBehavior", "Module"
      include shared_name
    when "String"
      include const_get(shared_name.to_module_name)
    when "Symbol"
      include const_get(shared_name.to_s.to_module_name)
    else
      raise ArgumentError, "Provide a String or Symbol as the name of the shared behavior group or the module name"
    end
  end
  %w(uses it_should_behave_like behaves_like uses_examples_from).each {|m| alias_method m, :use}
end

require 'address_standardization'
AddressStandardization.debug_mode = true