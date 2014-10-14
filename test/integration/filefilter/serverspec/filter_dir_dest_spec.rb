require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'filefilter::filter_dir_dest' do

  describe file('/tmp/filefilter/filter_dir_dest_txt/testfile.txt') do
    it { should be_file }

    its(:content) { should match(/These are tokens that should be replaced: a, b, and c       ./) }
    its(:content) { should match(/These are tokens that shouldn't be replaced: @TOKA@, @TOKB@, and @TOKC@./) }
  end

  describe file('/tmp/filefilter/filter_dir_dest_txt/testfile1.txt') do
    it { should be_file }

    its(:content) { should match(/These are tokens that should be replaced: a, b, and c       ./) }
    its(:content) { should match(/These are tokens that shouldn't be replaced: @TOKA@, @TOKB@, and @TOKC@./) }
  end

  describe file('/tmp/filefilter/filter_dir_dest_txt/subdir/testfile2.txt') do
    it { should be_file }

    its(:content) { should match(/These are tokens are mixed: a, @TOKA@, b, @TOKB@, c        and @TOKC@./) }
  end

  describe file('/tmp/filefilter/filter_dir_dest_txt/subdir/subdir/testfile3.txt') do
    it { should be_file }

    its(:content) { should match(/These are tokens are mixed: a, a, b, \$\{TOK2\}, c        and/) }
  end

  describe file('/tmp/filefilter/filter_dir_dest_tst/testfile1.tst') do
    it { should be_file }

    its(:content) do
      should match(/These are tokens are mixed: 1, @1@, 2, \$\{mytoken\}, 3        and/)
    end
  end

end
