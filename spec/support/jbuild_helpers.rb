module JbuildHelpers
  def jbuild *args, &block
    Jasonette::Template.new(test_view_context_class).jason &block
  end
  def build_with builder_class, &block
    builder_class.new(test_view_context_class, &block)
  end
end

RSpec.configure do |config|
  include JbuildHelpers
end
