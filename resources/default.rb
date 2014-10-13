actions :run
default_action :run

attribute :source, kind_of: String
attribute :destination,   kind_of: String, default: nil
attribute :tokens, kind_of: Hash, required: true
attribute :pattern, kind_of: [String, Array], default: '**' # See ::File.fnmatch?
attribute :begintoken, kind_of: String, default: '@'
attribute :endtoken,   kind_of: String, default: '@'
attribute :backup, kind_of: [TrueClass, FalseClass], default: true
attribute :recurse, kind_of: [TrueClass, FalseClass], default: true
attribute :owner, kind_of: String,  default: 'root'
attribute :group, kind_of: String,  default: 'root'
attribute :mode,  kind_of: Integer, default: 0644

def initialize(*args)
  super
  @source ||= @name
  @destination ||= @source
  @action = :run
end
