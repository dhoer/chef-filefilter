require 'spec_helper'

describe 'filefilter_test::filter_file_dest' do

  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ['filefilter']).converge(described_recipe) }

  before do
    allow(::File).to receive(:file?) { true }
    allow(::File).to receive(:rename)
    allow(::File).to receive(:open)
  end

  it 'sets up test directory' do
    expect(chef_run).to create_directory('/tmp/filefilter/filter_file')
  end

  it 'sets up test file' do
    expect(chef_run).to create_cookbook_file('files/testfile.txt').with(
      path: '/tmp/filefilter/filter_file/testfile.txt'
    )
  end

  it 'copies and filter file to new destination' do
    expect(chef_run).to run_filefilter('filter_to_new_dest').with(
      source: '/tmp/filefilter/filter_file_inplace/testfile.txt',
      owner: 'root',
      group: 'root',
      begintoken: '@',
      endtoken: '@',
      tokens: { TOK1: 'a', TOK2: 'b', TOK3: 'c       ' }
    )
  end

  it 'does not create a destination directory' do
    expect(chef_run).to create_directory('filefilter create directory /tmp/filefilter/filter_file_dest')
  end

  it 'creates a destination file' do
    expect(chef_run).to create_file('filefilter create destination file /tmp/filefilter/filter_file_dest/testfile.txt')
  end

end
