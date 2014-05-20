# set up common stuff first
include_recipe 'smartstack::default'

# set up nerve
directory node.nerve.home do
  recursive true
end

git node.nerve.install_dir do
    repository        node.nerve.repository
    reference         node.nerve.reference
    enable_submodules true
    action     :sync
end

#  do the actual install of nerve and dependencies
execute "nerve_install" do
    cwd     node.nerve.install_dir
    action  :run

    environment ({'GEM_HOME' => node.smartstack.gem_home})
    command     "/opt/rbenv/shims/bundle install --without development"
end

# add all checks from all the enabled services
# we do this in the recipe to avoid wierdness with attribute load order
node.nerve.enabled_services.each do |service_name|
  unless node.smartstack.services.include? service_name
    Chef::Log.warn "[nerve] skipping non-existent service #{service_name}"
    next
  end

  service = node.smartstack.services[service_name].deep_to_hash

  unless service.include? 'nerve'
    Chef::Log.warn "[nerve] skipping unconfigured service #{service_name}"
    next
  end

  check = service['nerve']
  check['zk_hosts'] = node.zookeeper.smartstack_cluster
  #check['zk_path'] = service['zk_path']
  #check['host'] = service['host']    #changed from node.ipaddress so it puts what we choose!

  # support multiple copies of the service on one machine with multiple ports in services
  check['ports'] ||= []
  check['ports'] << check['port'] if check['port']
  Chef::Log.warn "[nerve] service #{service_name} has no check ports configured" if check['ports'].empty?

  # add the checks to the nerve config
  check['ports'].each do |port|
    check['port'] = port
    node.default.nerve.config.services["#{service_name}_#{port}"] = check
  end
end

# write the config to the config file for nerve

nerve_hash = JSON::pretty_generate(node.nerve.config.deep_to_hash)
file node.nerve.config_file do
  content nerve_hash
end

# set up runit service
# we don't want a converge to randomly start nerve if someone is debugging
# so, we only enable nerve; setting it up initially causes it to start,
runit_service 'nerve' do
  action    :enable 
  default_logger true
end
