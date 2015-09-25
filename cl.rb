#!/usr/bin/env ruby

require 'scanf'

tags = `git tag --sort='version:refname' | grep '^v[0-9]'`.split("\n")
tags << 'HEAD'

def project_name
  repo_root = `git rev-parse --show-toplevel`.chomp
  repo_root << '/' if repo_root[-1] != '/'

  readme_path = "#{repo_root}README.md"
  if File.exist?(readme_path)
    f = File.open(readme_path, 'r')
    project_name = nil
    begin
      while line = f.gets
        if line[0,2] == '# '
          project_name = line[2..-1].strip
        end
      end
    ensure
      f.close
    end
    project_name or raise 'Project name not found, expected "# Name" in README.md'
  else
    raise 'README.md not found'
  end
  project_name
end

project = project_name

next_version = ARGV.shift || 'Next'

def commit_changelog_messages
  log = 'git log --log-size --format="%H%n%b" --grep "^cl:"'
  log_io = IO.popen(log)
  messages = {}
  begin
    while line = log_io.gets
      length = line.scanf('log size %d')[0]
      hash = log_io.readline.chomp
      messages[hash] = log_io.read(length - hash.length - 1)
      log_io.read(1)
    end
  ensure
    log_io.close
  end
  messages.each do |hash, message|
    messages[hash] = message.split("\n").select { |l| l =~ /^cl: / }[0][4..-1]
  end
  messages
end

CL_MESSAGES = commit_changelog_messages

deindenters = []

last_tag = nil
last_lists = []
lists = {}

tags.each do |tag|
  lists[tag] = {}
  current_list = lists[tag]['root'] = []
  rev_spec = last_tag ? "#{last_tag}..#{tag}" : "#{tag}"
  revs = `git rev-list --topo-order --parents #{rev_spec}`.split("\n")
  revs.each do |rev|
    commits = rev.split(' ')
    commit = commits[0]
    parents = commits[1..-1]
    if commit == deindenters.last
      deindenters.pop
      current_list = last_lists.pop
    end
    current_list << commit
    if parents.length > 1 && CL_MESSAGES[commit]
      deindenters << parents[0]
      last_lists << current_list
      current_list = lists[tag][commit] = []
    end
  end
  last_tag = tag
end

def print_lists(lists_for_tag, commit, indent = 0)
  lists_for_tag[commit].reverse.each do |c|
    if CL_MESSAGES.has_key?(c)
      puts "#{'  ' * indent}- #{CL_MESSAGES[c]}"
    end
    if lists_for_tag[c]
      print_lists(lists_for_tag, c, indent + 1)
    end
  end
end

puts "# #{project} change log"
tags.reverse.each_with_index do |tag, index|
  next unless lists[tag]['root'].any? { |l| CL_MESSAGES.has_key?(l) }
  puts unless index == 0
  puts tag == 'HEAD' ? "## #{next_version}" : "## #{tag}"
  print_lists(lists[tag], 'root')
end
