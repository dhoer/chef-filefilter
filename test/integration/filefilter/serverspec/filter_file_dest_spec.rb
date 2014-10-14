require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'filefilter::filter_file_dest' do

  describe file('/tmp/filefilter/filter_file_inplace/testfile.txt') do
    it { should be_file }

    its(:content) { should match(/These are tokens that should be replaced: a, b, and c       ./) }
    its(:content) { should match(/These are tokens that shouldn't be replaced: @TOKA@, @TOKB@, and @TOKC@./) }
  end

  describe file('/tmp/filefilter/filter_file_inplace/testfile1.txt') do
    it { should be_file }

    its(:content) { should match(/These are tokens that should be replaced: 1, 2, and 3       ./) }
    its(:content) { should match(/These are tokens that shouldn't be replaced: @TOKA@, @TOKB@, and @TOKC@./) }
  end

end
