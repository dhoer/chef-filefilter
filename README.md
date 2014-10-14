# FileFilter Cookbook

[![Build Status](https://travis-ci.org/dhoer/chef-filefilter.svg)](https://travis-ci.org/dhoer/chef-filefilter)

A Chef LWRP that searches and replaces tokens in a single file or designated files in a directory.
It is modeled after [Ant's FilterSet](http://ant.apache.org/manual/Types/filterset.html), so it can filter 
with [Maven delimiters](http://maven.apache.org/plugins/maven-resources-plugin/examples/filter.html) as well.

## Requirements

Chef 11.14.2 and Ruby 1.9.3 or higher.

### Platform

- ubuntu
- centos

## Usage

Replaces all occurrences of tokens `@host@` with `http://example.com` and `@port@` with `80` in file:

```ruby
filefilter 'src/myfile.txt' do
  tokens(
    host: '10.25.0.5'
    port: 80
  )
end
```

Processes all `.sql` files in a directory replacing the `@TABLE@` token:

```ruby
filefilter 'src/dir' do
  pattern '*.sql'
  tokens(
    TABLE: 'mytable' 
  )
end
```

Copies all `.sql` files in source directory to target directory, replacing the `${db_schema}` and `${db.somevalue}` 
tokens.  Note the slash used to escape the `$` in the begintoken attribute.  The token name `db.somevalue` is 
not a valid symbol since it contains a period; use the `"string".to_sym` to allow this:

```ruby
filefilter 'src/dir' do
  destination 'target/dir'
  begintoken '\${'
  endtoken '}'
  pattern '*.sql'
  tokens(
    :db_schema => 'some value here',
    'db.somevalue'.to_sym => 'other value',
  )
end
```

## Resource

### Attributes

This resource has the following attributes:
<table>
  <tr>
    <th>Key</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>source</tt></td>
    <td>The source file or directory to be filtered. Defaults to <tt>name</tt> if attribute omitted.</td>
  </tr>
  <tr>
    <td><tt>destination</tt></td>
    <td>The destination file or directory.  Defaults to <tt>source</tt> if attribute omitted.</td>
  </tr>
  <tr>
    <td><tt>tokens</tt></td>
    <td>One or more token strings without begintoken/endtoken separator chars (e.g., <tt>@</tt>) and the value string
        that should be put to replace the token when the file is copied.</td>
  </tr>
  <tr>
    <td><tt>begintoken</tt></td>
    <td>The string marking the beginning of a token (e.g., <tt>@DATE@</tt>, <tt>${DATE}</tt>). Escape the token value of 
        <tt>$</tt> with two back slashes if in double quotes or a single back slash in single quotes to prevent it from 
        trying to interpret as a regular expression (e.g., <tt>"\\${"</tt> or <tt>'\${'</tt>).  Default value: 
        <tt>@</tt></td>
  </tr>
  <tr>
    <td><tt>endtoken</tt></td>
    <td>The string marking the end of a token (eg., <tt>@DATE@</tt>).  Default value: <tt>@</tt></td>
  </tr>
  <tr>
    <td><tt>pattern</tt></td>
    <td>The file name pattern to match inside a directory.  Default value: <tt>**</tt>, see 
        http://www.ruby-doc.org/core-2.1.3/File.html#method-c-fnmatch for more info.</td>
  </tr>
  <tr>
    <td><tt>recurse</tt></td>
    <td>When processing a directory, controls whether or not subdirectories are checked and processed.  Default value: 
        <tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>backup</tt></td>
    <td>Backup source file, if source and destination are the same. The backup file will be in the same directory and
        have ".#{node['filefilter']['strftime']#{node['filefilter']['file_extension']}" appended to the original
        filename. Default value: <tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>owner</tt></td>
    <td>The owner of the file. Default value: <tt>root</tt></td>
  </tr>
  <tr>
    <td><tt>group</tt></td>
    <td>The group owner of the file. Default value: <tt>root</tt></td>
  </tr>
  <tr>
    <td><tt>mode</tt></td>
    <td>File permissions. Default value: <tt>0644</tt></td>
  </tr>
</table>

### Actions

This resource has the following attributes:
<table>
  <tr>
    <th>Key</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>:run</tt></td>
    <td>Filter tokens in a single file or designated files in a directory.</td>
  </tr>
</table>

## ChefSpec Matchers

The FileFilter cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test 
your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to run_filefilter('name').with(
  tokens: {
    hostname: '10.25.0.5',
    port: 80
  }
)
```
      
FileFilter Cookbook Matchers

- run_filefilter(name)

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chef-filefilter).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-filefilter/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-filefilter/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-filefilter/blob/master/LICENSE.md) file for details.
