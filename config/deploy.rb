# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'puma'
set :repo_url, 'https://github.com/LorenzoBaracchi/puma_test.git'
set :git_https_username, 'LorenzoBaracchi'
set :git_https_password, ENV['GITPWD']

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/puma'
set :puma_conf, '/var/www/puma/current/config/puma.rb'
set :puma_pid, "/var/www/puma/shared/tmp/pids/puma.pid"
set :puma_access_log, "/var/log/puma_access.log"
set :puma_error_log, "/var/log/puma_error.log"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :assets_roles, [:web, :app]

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
       within release_path do
         with rails_env: fetch(:rails_env) do
           execute :rake, 'assets:precompile'
         end
       end
    end
  end

end
