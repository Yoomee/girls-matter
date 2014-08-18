require ::File.expand_path('../../lib/capistrano/database_tasks',  __FILE__)
# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'girls-matter'
set :repo_url, 'git@gitlab.yoomee.com:girlguiding/girlguiding.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.env}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Use SSH agent forwarding
set :ssh_options, { forward_agent: true}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :assets do
  desc "Precompile assets locally and then rsync to web servers"
  task :precompile do
    # Precompile assets
    run_locally do
      with rails_env: fetch(:stage) do
        execute :bundle, "exec rake assets:precompile"
      end
    end
    # rsync to web servers
    on roles(:web) do
      rsync_host = host.to_s # this needs to be done outside run_locally in order for host to exist
      run_locally do
        execute "rsync -av --delete ./public/assets/ deploy@#{rsync_host}:#{release_path}/public/assets/"
      end
    end
    # Remove precompiled assets
    run_locally do
      execute "rm -rf public/assets"
    end
  end
end

namespace :deploy do

  after :updated, "assets:precompile"

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
