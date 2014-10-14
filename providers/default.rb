def source_destination_match?(source, destination)
  ::File.path(source) == ::File.path(destination)
end

def backup(source)
  target = "#{source}.#{Time.now.strftime(node['filefilter']['strftime'])}#{node['filefilter']['file_extension']}"
  ::File.rename(source, target)
  target
end

def remove_backup(backup, source, destination)
  ::File.rm(source) if !backup && source_destination_match?(source, destination)
end

def filter(source, destination)
  create_destination(destination, new_resource.owner, new_resource.group, new_resource.mode)
  filter_file(source, destination, new_resource.tokens, new_resource.begintoken, new_resource.endtoken)
end

def create_destination(destination, owner, group, mode)
  dirname = ::File.dirname(destination)
  create_directory(dirname) unless ::Dir.exist?(dirname)
  file "filefilter create file #{destination}" do
    path destination
    owner owner
    group group
    mode mode
  end.run_action(:create)
end

def create_directory(dirname)
  directory "filefilter create directory #{dirname}" do
    path dirname
    recursive true
    mode 00755
    not_if { ::Dir.exist?(dirname) }
  end.run_action(:create)
end

def filter_file(infile, outfile, tokens, begintoken, endtoken)
  ::File.open(outfile, 'w+') do |output|
    ::File.open(infile).each do |line|
      output.puts replace(line, tokens, begintoken, endtoken)
    end
  end
end

def replace(text, tokens, begintoken, endtoken)
  out = text.clone
  tokens.keys.each do |key|
    out.gsub!(/#{begintoken}#{key}#{endtoken}/, tokens[key])
  end
  out
end

def process_file(file)
  dst_dir = new_resource.destination
  name  = ::File.basename(file)
  rel_name = file.gsub(new_resource.source, '')
  Array(new_resource.pattern).each do |p|
    next unless ::File.fnmatch(p, name)
    detokenize(::File.expand_path(file), ::File.expand_path(::File.join(dst_dir, rel_name)))
  end
end

def detokenize(source, destination)
  source = backup(source) if source_destination_match?(source, destination)
  filter(source, destination)
  remove_backup(new_resource.backup, source, destination)
end

def process_entries(ent)
  if ::File.directory?(ent) && new_resource.recurse
    process_dir(ent)
  elsif ::File.file?(ent) || ::File.symlink?(ent)
    process_file(ent)
  end
end

def process_dir(dir)
  # recursively process sub directories
  ::Dir.foreach(dir) do |dir_ent|
    next if dir_ent == '.' || dir_ent == '..'
    process_entries(::File.join(dir, dir_ent))
  end
end

action :run do
  src = new_resource.source
  if ::File.directory?(src)
    process_dir(src)
  elsif ::File.file?(src)
    detokenize(src, new_resource.destination)
  else
    fail "FileFilter #{src} does not exist!"
  end
  new_resource.updated_by_last_action(true)
end
