require 'spec_helper'

describe 'filefilter_test::filter_file_dest' do

  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ['filefilter']).converge(described_recipe) }

  before do
    allow(::File).to receive(:file?) { true }
    allow(::File).to receive(:rename)
    allow(::File).to receive(:open)
  end

  it 'sets up test' do
    expect(chef_run).to create_directory('/tmp/filefilter/filter_file')
    expect(chef_run).to create_cookbook_file('files/testfile.txt').with(
      path: '/tmp/filefilter/filter_file/testfile.txt'
    )
    expect(chef_run).to create_cookbook_file('files/testfile1.txt').with(
      path: '/tmp/filefilter/filter_file/testfile1.txt'
    )
  end

  it 'copies and filter file to new absolute destination' do
    expect(chef_run).to run_filefilter('filter_to_new_dest_absolute_path').with(
      source: '/tmp/filefilter/filter_file/testfile.txt',
      destination: '/tmp/filefilter/filter_file_dest/testfile.txt',
      owner: 'root',
      group: 'root',
      begintoken: '@',
      endtoken: '@',
      tokens: { TOK1: 'a', TOK2: 'b', TOK3: 'c       ' }
    )
  end

  it 'does not create a destination directory' do
    expect(chef_run).to create_directory('filefilter create directory for filter_to_new_dest_absolute_path')
  end

  it 'creates a destination file' do
    expect(chef_run).to create_file('filefilter create file for filter_to_new_dest_absolute_path')
  end

  it 'copies and filter file to new relative destination' do
    expect(chef_run).to run_filefilter('filter_to_new_dest_relative_path').with(
      source: 'tmp/filefilter/filter_file/testfile1.txt',
      destination: 'tmp/filefilter/filter_file_dest/testfile1.txt',
      owner: 'root',
      group: 'root',
      begintoken: '@',
      endtoken: '@',
      tokens: { TOK1: '1', TOK2: '2', TOK3: '3       ' }
    )
  end

  it 'does not create a destination directory' do
    expect(chef_run).to create_directory('filefilter create directory for filter_to_new_dest_relative_path')
  end

  it 'creates a destination file' do
    expect(chef_run).to create_file('filefilter create file for filter_to_new_dest_relative_path')
  end

end
