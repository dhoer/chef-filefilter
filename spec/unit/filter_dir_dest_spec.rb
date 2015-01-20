require 'spec_helper'

describe 'filefilter_test::filter_dir_dest' do
  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ['filefilter']).converge(described_recipe) }

  before do
    allow(::File).to receive(:file?) { true }
    allow(::File).to receive(:rename)
    allow(::File).to receive(:open)
  end

  it 'sets up test' do
    expect(chef_run).to create_directory('/tmp/filefilter/filter_dir/subdir/subdir')
    expect(chef_run).to create_cookbook_file('files/testfile.txt').with(
      path: '/tmp/filefilter/filter_dir/testfile.txt'
    )
    expect(chef_run).to create_cookbook_file('files/testfile1.tst').with(
      path: '/tmp/filefilter/filter_dir/testfile1.tst'
    )
    expect(chef_run).to create_cookbook_file('files/testfile1.txt').with(
      path: '/tmp/filefilter/filter_dir/testfile1.txt'
    )
    expect(chef_run).to create_cookbook_file('files/testfile2.txt').with(
      path: '/tmp/filefilter/filter_dir/subdir/testfile2.txt'
    )
    expect(chef_run).to create_cookbook_file('files/testfile3.txt').with(
      path: '/tmp/filefilter/filter_dir/subdir/subdir/testfile3.txt'
    )
  end

  it 'copies and filter directory to new absolute destination' do
    expect(chef_run).to run_filefilter('filter_text_files_recurse_absolute_path').with(
      source: '/tmp/filefilter/filter_dir',
      destination: '/tmp/filefilter/filter_dir_dest_txt',
      pattern: '*.txt',
      owner: 'root',
      group: 'root',
      begintoken: '@',
      endtoken: '@',
      tokens: { TOK1: 'a', TOK2: 'b', TOK3: 'c       ' }
    )
  end

  it 'creates a destination directory' do
    expect(chef_run).to create_directory('filefilter create directory for filter_text_files_recurse_absolute_path')
  end

  it 'creates a destination file' do
    expect(chef_run).to create_file('filefilter create file for filter_text_files_recurse_absolute_path')
  end

  it 'copies and filter directory to new relative destination' do
    expect(chef_run).to run_filefilter('filter_text_files_recurse_relative_path').with(
      source: 'tmp/filefilter/filter_dir',
      destination: 'tmp/filefilter/filter_dir_dest_tst',
      pattern: '*.tst',
      owner: 'root',
      group: 'root',
      begintoken: '@',
      endtoken: '@',
      tokens: { TOK1: '1', TOK2: '2', TOK3: '3       ' }
    )
  end

  it 'creates a destination directory' do
    expect(chef_run).to create_directory('filefilter create directory for filter_text_files_recurse_relative_path')
  end

  it 'creates a destination file' do
    expect(chef_run).to create_file('filefilter create file for filter_text_files_recurse_relative_path')
  end

  it 'copies and filter directory to new destination with no recurse' do
    expect(chef_run).to run_filefilter('filter_text_files_no_recurse_absolute_path').with(
      source: '/tmp/filefilter/filter_dir',
      destination: '/tmp/filefilter/filter_dir_dest_txt_no_recurse',
      pattern: '*.txt',
      recurse: false,
      owner: 'root',
      group: 'root',
      begintoken: '@',
      endtoken: '@',
      tokens: { TOK1: 'a', TOK2: 'b', TOK3: 'c       ' }
    )
  end

  it 'creates a destination file' do
    expect(chef_run).to create_directory('filefilter create directory for filter_text_files_no_recurse_absolute_path')
  end

  it 'creates a destination file' do
    expect(chef_run).to create_file('filefilter create file for filter_text_files_no_recurse_absolute_path')
  end
end
