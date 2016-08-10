class GitDiffer

  def self.execute
    require 'rugged'

    paths = [];

    repo = Rugged::Repository.new('.')

    walker = Rugged::Walker.new(repo)

    walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_REVERSE)
    walker.push(repo.head.target)
    walker.each do |commit|
      # skip merges
      next if commit.parents.count != 1

      diffs = commit.parents[0].diff(commit)
      diffs.each_delta do |delta|
        paths += [delta.old_file[:path], delta.new_file[:path]]
      end

    end

    paths
  end

end