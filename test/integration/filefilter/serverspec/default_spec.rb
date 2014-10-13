require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'filefilter' do

  describe file('/tmp/testfile.txt') do
    it { should be_file }

    its(:content) { should match(/These are tokens that should be replaced: a, b, and c       ./) }
    its(:content) { should match(/These are tokens that shouldn't be replaced: @TOKA@, @TOKB@, and @TOKC@./) }
  end

end
