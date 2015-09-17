#!/usr/bin/env ruby

tags = `git tag --sort='version:refname' | grep '^v[0-9]'`.split("\n")
tags << 'HEAD'

commits_with_messages = `git log --log-size --format='%H%n%b' --grep '^cl:'`

deindenters = []

last_tag = nil

tags.each do |tag|
  indent_level = 0
  puts tag
  rev_spec = last_tag ? "#{last_tag}..#{tag}" : "#{tag}"
  revs = `git rev-list --topo-order --parents #{rev_spec}`.split("\n")
  revs.each do |rev|
    commits = rev.split(' ')
    commit = commits[0]
    parents = commits[1..-1]
    if commit == deindenters.last
      indent_level -= 1
      deindenters.pop
    end
    puts "#{'  ' * indent_level}- #{commit}"
    if parents.length > 1
      deindenters << parents[0]
      indent_level += 1
    end
  end
  last_tag = tag
  puts
end
