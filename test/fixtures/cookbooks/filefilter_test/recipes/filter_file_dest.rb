directory '/tmp/filefilter/filter_file' do
  recursive true
  action :create
end

cookbook_file 'files/testfile.txt' do
  path '/tmp/filefilter/filter_file/testfile.txt'
  action :create
end

filefilter 'filter_to_new_dest_absolute_path' do
  source '/tmp/filefilter/filter_file/testfile.txt'
  destination '/tmp/filefilter/filter_file_dest/testfile.txt'
  tokens(
    TOK1: 'a',
    TOK2: 'b',
    TOK3: 'c       '
  )
end

cookbook_file 'files/testfile1.txt' do
  path '/tmp/filefilter/filter_file/testfile1.txt'
  action :create
end

filefilter 'filter_to_new_dest_relative_path' do
  source 'tmp/filefilter/filter_file/testfile1.txt'
  destination 'tmp/filefilter/filter_file_dest/testfile1.txt'
  tokens(
    TOK1: '1',
    TOK2: '2',
    TOK3: '3       '
  )
end
