directory '/tmp/filefilter/filter_file_inplace' do
  recursive true
  action :create
end

cookbook_file 'files/testfile.txt' do
  path '/tmp/filefilter/filter_file_inplace/testfile.txt'
  action :create
end

filefilter 'filter_inplace' do
  source '/tmp/filefilter/filter_file_inplace/testfile.txt'
  tokens(
    TOK1: 'a',
    TOK2: 'b',
    TOK3: 'c       '
  )
end
