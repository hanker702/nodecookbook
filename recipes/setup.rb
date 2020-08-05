node_app_setup 'node-app' do
  nodejs_version node['opsworks-node-app']['nodejs']['version']
  nodejs_checksum node['opsworks-node-app']['nodejs']['checksum']
end
