directory '/tmp/filefilter/filter_dir/subdir/subdir' do
  recursive true
  action :create
end

cookbook_file 'files/testfile.txt' do
  path '/tmp/filefilter/filter_dir/testfile.txt'
  action :create
end

cookbook_file 'files/testfile1.tst' do
  path '/tmp/filefilter/filter_dir/testfile1.tst'
  action :create
end

cookbook_file 'files/testfile1.txt' do
  path '/tmp/filefilter/filter_dir/testfile1.txt'
  action :create
end

cookbook_file 'files/testfile2.txt' do
  path '/tmp/filefilter/filter_dir/subdir/testfile2.txt'
  action :create
end

cookbook_file 'files/testfile3.txt' do
  path '/tmp/filefilter/filter_dir/subdir/subdir/testfile3.txt'
  action :create
end

filefilter 'filter_text_files_recurse_absolute_path' do
  source '/tmp/filefilter/filter_dir'
  destination '/tmp/filefilter/filter_dir_dest_txt'
  pattern '*.txt'
  tokens(
    TOK1: 'a',
    TOK2: 'b',
    TOK3: 'c       '
  )
  action :run
end

filefilter 'filter_text_files_recurse_relative_path' do
  source 'tmp/filefilter/filter_dir'
  destination 'tmp/filefilter/filter_dir_dest_tst'
  pattern '*.tst'
  tokens(
    TOK1: '1',
    TOK2: '2',
    TOK3: '3       '
  )
  action :run
end

filefilter 'filter_text_files_no_recurse_absolute_path' do
  source '/tmp/filefilter/filter_dir'
  destination '/tmp/filefilter/filter_dir_dest_txt_no_recurse'
  recurse false
  pattern '*.txt'
  tokens(
    TOK1: 'a',
    TOK2: 'b',
    TOK3: 'c       '
  )
  action :run
end
