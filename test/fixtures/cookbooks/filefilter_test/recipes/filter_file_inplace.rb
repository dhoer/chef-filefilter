directory '/tmp/filefilter/filter_file_inplace' do
  recursive true
  action :create
end

cookbook_file 'files/testfile.txt' do
  path '/tmp/filefilter/filter_file_inplace/testfile.txt'
  action :create
end

# absolute path
filefilter '/tmp/filefilter/filter_file_inplace/testfile.txt' do
  tokens(
    TOK1: 'a',
    TOK2: 'b',
    TOK3: 'c       '
  )
  action :run
end

cookbook_file 'files/testfile1.txt' do
  path '/tmp/filefilter/filter_file_inplace/testfile1.txt'
  action :create
end

# relative path
filefilter 'tmp/filefilter/filter_file_inplace/testfile1.txt' do
  tokens(
    TOK1: '1',
    TOK2: '2',
    TOK3: '3       '
  )
  action :run
end
