if defined?(ChefSpec)
  ChefSpec.define_matcher :filefilter

  def run_filefilter(name)
    ChefSpec::Matchers::ResourceMatcher.new(:filefilter, :run, name)
  end
end
