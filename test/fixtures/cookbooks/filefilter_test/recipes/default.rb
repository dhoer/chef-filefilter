cookbook_file 'files/testfile.txt' do
  path '/tmp/testfile.txt'
  action :create
end

filefilter 'tmp/testfile.txt' do
  tokens(
    TOK1: 'a',
    TOK2: 'b',
    TOK3: 'c       '
  )
end

directory '/tmp/testdir' do
  action :create
end

cookbook_file 'files/testfile1.tst' do
  path '/tmp/testdir/testfile1.tst'
  action :create
end

cookbook_file 'files/testfile1.txt' do
  path '/tmp/testdir/testfile1.txt'
  action :create
end

cookbook_file 'files/testfile2.txt' do
  path '/tmp/testdir/testfile2.txt'
  action :create
end

cookbook_file 'files/testfile3.txt' do
  path '/tmp/testdir/testfile3.txt'
  action :create
end

filefilter 'tmp/testdir' do
  destination 'tmp/newtarget/'
  pattern '*.txt'
  tokens(
    TOK1: '1',
    TOK2: '2',
    TOK3: '3       '
  )
end

filefilter 'tmp/testdir' do
  pattern '*.txt'
  tokens(
    TOK1: 'a',
    TOK2: 'b',
    TOK3: 'c       '
  )
end

filefilter 'tmp/testdir' do
  pattern '*.tst'
  begintoken '\${'
  endtoken '}'
  tokens(
    'my.token'.to_sym => 'ah'
  )
end
