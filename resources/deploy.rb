property :ssh_key, String
property :dir, String, required: true
property :git_repository, String, required: true
property :git_revision, String, default: 'master'
property :service_name, String, required: true, name_property: true
property :run_cmd, String, default: '/usr/local/bin/npm start'
property :run_environment, Hash, default: {}

default_action :run

action :run do
  file '/root/.ssh/id_rsa' do
    mode '0400'
    content ssh_key
  end

  git dir do
    repository git_repository
    revision git_revision
    action :sync
  end

  execute "npm prune #{service_name}" do
    command 'npm prune'
    cwd dir
  end

  execute "npm install #{service_name}" do
    command 'npm install'
    cwd dir
  end

  template "/etc/init/#{service_name}.conf" do
    source 'upstart.conf.erb'
    cookbook 'node-app'
    mode '0600'
    variables(
      name: service_name,
      chdir: dir,
      cmd: run_cmd,
      environment: run_environment
    )
    notifies :stop, "service[#{service_name}]", :delayed
    notifies :start, "service[#{service_name}]", :delayed
  end

  service service_name do
    provider Chef::Provider::Service::Upstart
    action :start
    subscibes :restart, "git[#{dir}]", :delayed
    subscibes :restart, "execute[npm prune #{service_name}]", :delayed
    subscibes :restart, "execute[npm install #{service_name}]", :delayed
  end
end
