node_app_setup 'myapp' do
  nodejs_version '5.10.1'
  nodejs_checksum '...'
end

# let's deploy `myapp`
node_app_deploy 'myapp' do # service_name defaults to this name
  ssh_key '...'
  dir '/opt/myapp'
  git_repository '<repository>'
  git_revision 'master'
  run_cmd 'npm start'
  run_environment(
    'NODE_ENV' => 'production',
    'PORT' => 8080
  )
end
