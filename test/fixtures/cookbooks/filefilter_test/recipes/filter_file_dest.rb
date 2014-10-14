directory '/tmp/filefilter/filter_file' do
  recursive true
  action :create
end

cookbook_file 'files/testfile.txt' do
  path '/tmp/filefilter/filter_file/testfile.txt'
  action :create
end

filefilter 'filter_to_new_dest' do
  source '/tmp/filefilter/filter_file_inplace/testfile.txt'
  destination '/tmp/filefilter/filter_file_dest/testfile.txt'
  tokens(
    TOK1: 'a',
    TOK2: 'b',
    TOK3: 'c       '
  )
end
