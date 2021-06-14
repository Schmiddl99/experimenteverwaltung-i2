set :application, 'EMS'
# set :repo_url, 'git@host:user/app.git'

set :rvm_type, :user
set :rvm_ruby_version, '3.0.1'

set :scm, :copy
set :repository, "."
set :deploy_via, :copy

set :bundle_flags, '--quiet'
set :format, :pretty
set :pty, true
set :log_level, :info

set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets public/uploads bundle backups]
# set :linked_files, %w[db/production.sqlite3]

set :keep_releases, 5

namespace :server do
  desc 'Service Helper'

  task :console do
    on roles(:app) do |host|
      command = "rails console -e production"
      exec "ssh #{host.netssh_options[:user]}@#{host} -t 'cd #{fetch(:deploy_to)}/current &&  ~/.rvm/bin/rvm default do bundle exec #{command}'"
    end
  end

  task :backup do
    on roles(:app) do |host|
      exec "ssh #{host.netssh_options[:user]}@#{host} -t '#{fetch(:deploy_to)}/current/bin/backups'"
    end
  end
end

namespace :deploy do
  namespace :assets do
    before :backup_manifest, 'deploy:assets:create_manifest_json'
    task :create_manifest_json do
      on roles :web do
        within release_path do
          execute "mkdir #{release_path}/assets_manifest_backup"
          execute "touch #{release_path}/public/assets/manifest.json"
        end
      end
    end
  end

  before :finishing, 'deploy:restart'

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      within "#{fetch(:deploy_to)}/current/" do
        execute "touch #{fetch(:deploy_to)}/current/tmp/restart.txt"
        execute "curl --silent #{fetch(:app_domain)}"
      end
    end
  end
  task :database_config do
    on roles(:app) do
      within release_path do
        execute "cp #{release_path}/config/database_live.yml #{release_path}/config/database.yml"
      end
    end
  end

  after "deploy:updating", "deploy:database_config"
  after :finishing, 'deploy:cleanup'
end
