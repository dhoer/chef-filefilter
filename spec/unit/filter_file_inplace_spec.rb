require 'spec_helper'

describe 'filefilter_test::filter_file_inplace' do
  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ['filefilter']).converge(described_recipe) }

  before do
    allow(::File).to receive(:file?) { true }
    allow(::File).to receive(:rename)
    allow(::File).to receive(:open)
  end

  it 'sets up test' do
    expect(chef_run).to create_directory('/tmp/filefilter/filter_file_inplace')
    expect(chef_run).to create_cookbook_file('files/testfile.txt').with(
      path: '/tmp/filefilter/filter_file_inplace/testfile.txt'
    )
    expect(chef_run).to create_cookbook_file('files/testfile1.txt').with(
      path: '/tmp/filefilter/filter_file_inplace/testfile1.txt'
    )
  end

  it 'filters file in-place where name is source with absolute path' do
    expect(chef_run).to run_filefilter('/tmp/filefilter/filter_file_inplace/testfile.txt').with(
      source: '/tmp/filefilter/filter_file_inplace/testfile.txt',
      owner: 'root',
      group: 'root',
      begintoken: '@',
      endtoken: '@',
      tokens: { TOK1: 'a', TOK2: 'b', TOK3: 'c       ' }
    )
  end

  it 'creates destination directory' do
    expect(chef_run).to create_directory(
      'filefilter create directory for /tmp/filefilter/filter_file_inplace/testfile.txt'
    )
  end

  it 'creates a destination file' do
    expect(chef_run).to create_file('filefilter create file for /tmp/filefilter/filter_file_inplace/testfile.txt')
  end

  it 'filters file in-place where name is source with relative path' do
    expect(chef_run).to run_filefilter('tmp/filefilter/filter_file_inplace/testfile1.txt').with(
      source: 'tmp/filefilter/filter_file_inplace/testfile1.txt',
      owner: 'root',
      group: 'root',
      begintoken: '@',
      endtoken: '@',
      tokens: { TOK1: '1', TOK2: '2', TOK3: '3       ' }
    )
  end

  it 'creates destination directory' do
    expect(chef_run).to create_directory(
      'filefilter create directory for tmp/filefilter/filter_file_inplace/testfile1.txt'
    )
  end

  it 'creates a destination file' do
    expect(chef_run).to create_file('filefilter create file for tmp/filefilter/filter_file_inplace/testfile1.txt')
  end
end
