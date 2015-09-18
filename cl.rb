#!/usr/bin/env ruby

tags = `git tag --sort='version:refname' | grep '^v[0-9]'`.split("\n")
tags << 'HEAD'

commits_with_messages = `git log --log-size --format='%H%n%b' --grep '^cl:'`

$subjects = Hash[`git log --format='%H|||%s'`.split("\n").map { |l| l.split('|||') }]

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
    if parents.length > 1
      deindenters << parents[0]
      last_lists << current_list
      current_list = lists[tag][commit] = []
    end
  end
  last_tag = tag
end

def print_lists(lists_for_tag, commit, indent = 0)
  lists_for_tag[commit].reverse.each do |c|
    puts "#{'  ' * indent} - #{$subjects[c]}"
    if lists_for_tag[c]
      print_lists(lists_for_tag, c, indent + 1)
    end
  end
end

tags.reverse.each do |tag|
  puts tag
  print_lists(lists[tag], 'root')
  puts
end
