set :rails_env, :production
set :deploy_to, '/var/www/app'
set :app_domain, 'https://mphyda-test.mw.htw-dresden.de'

server 'mphyda-test.mw.htw-dresden.de',
  user: 'witt',
  roles: %w[web app db],
  ssh_options: {
    keys: %w[~/.ssh/id_rsa],
    forward_agent: false,
    auth_methods: %w[publickey password]
  }
