if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method :filefilter

  def filter_filefilter(name)
    ChefSpec::Matchers::ResourceMatcher.new(:filefilter, :filter, name)
  end
end
