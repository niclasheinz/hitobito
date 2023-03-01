# frozen_string_literal: true

module Release
  # lowlevel tooling
  module Lowlevel
    private

    def rake(task)
      notify "running rake #{task}"
      execute "bash -l -c 'bundle exec rake #{task}'"
    end

    def branch(name)
      notify "switching to branch #{name}"
      execute "git checkout #{name}"
    end

    def fast_forward(name)
      remote = `git remote | head -n 1`.chomp
      execute "git merge --ff-only #{remote}/#{name}"
    end

    def add(files)
      notify 'staging files'
      execute "git add -v #{files}"
    end

    def commit(message)
      notify 'committing'
      with_env({ 'SKIP' => 'RuboCop,UpdatedLicenseHeader' }) do
        execute "git commit -m '#{message}'"
      end
    end

    def fix_submodules
      notify 'reparing submodules'
      execute 'git submodule init && git submodule sync && git submodule update'
    end

    def submodules(action)
      notify 'executing action in all submodule'
      execute "git submodule foreach '#{action}'"
    end

    def submodule_status
      notify 'submodule status'
      execute 'git submodule status'
    end

    def tag(name)
      notify "tagging #{name}"
      execute "git tag -f #{name}"
    end

    def push
      notify 'pushing code and tags'
      confirm_and_execute 'git push origin && git push origin --tags'
    end
  end
end
