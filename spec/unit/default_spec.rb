require 'spec_helper'

describe 'filefilter_test::default' do
  let(:chef_run) { ChefSpec::Runner.new(step_into: ['filefilter']).converge(described_recipe) }

  before do
    allow(::File).to receive(:file?) { true }
    allow(::File).to receive(:rename)
    allow(::File).to receive(:open)
  end

  it 'creates tmp directory' do
    expect(chef_run).to create_directory('tmp')
  end

  it 'creates testdir directory' do
    expect(chef_run).to create_directory('/tmp/testdir')
  end

  it 'copies testfile.txt' do
    expect(chef_run).to create_cookbook_file('files/testfile.txt')
  end

  it 'copies testfile1.tst' do
    expect(chef_run).to create_cookbook_file('files/testfile1.tst')
  end

  it 'copies testfile1.txt' do
    expect(chef_run).to create_cookbook_file('files/testfile1.txt')
  end

  it 'copies testfile2.txt' do
    expect(chef_run).to create_cookbook_file('files/testfile2.txt')
  end

  it 'copies testfile3.txt' do
    expect(chef_run).to create_cookbook_file('files/testfile3.txt')
  end

  it 'filter file' do
    expect(chef_run).to run_filefilter('tmp/testfile.txt').with(
      owner: 'root',
      group: 'root',
      begintoken: '@',
      endtoken: '@',
      tokens: { TOK1: 'a', TOK2: 'b', TOK3: 'c       ' }
    )
  end

  it 'creates testfile.txt' do
    expect(chef_run).to create_file('tmp/testfile.txt')
  end

  it 'creates newtarget directory' do
    expect(chef_run).to create_file('tmp/newtarget/')
  end

  it 'filters *.tst files' do
    expect(chef_run).to run_filefilter('tmp/testdir').with(
      owner: 'root',
      group: 'root',
      begintoken: '\${',
      endtoken: '}',
      tokens: { :'my.token' => 'ah' },
      pattern: '*.tst',
      recurse: true
    )
  end
end
