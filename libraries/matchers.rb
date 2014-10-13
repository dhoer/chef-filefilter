if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method :filefilter

  def run_filefilter(name)
    ChefSpec::Matchers::ResourceMatcher.new(:filefilter, :run, name)
  end
end
