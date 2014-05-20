include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'
include_recipe 'ruby_build'

# set up common smartstack stuff
user node.smartstack.user do
  home    node.smartstack.home
  shell   '/sbin/nologin'
  system  true
end

directory node.smartstack.home do
  owner     node.smartstack.user
  group     node.smartstack.user
  recursive true
end

# we need git to install smartstack
package 'git'

# we use runit to set up the services
include_recipe 'runit'

# we're going to need ruby too!
rbenv_ruby node['smartstack']['ruby'] do
    action :install
    global true
end 

rbenv_gem "bundler" do
    action :install
end

#rbenv_gem "nerve" do
#    action :install
#end

# clean up old crap
# TODO: remove eventually
%w{/opt/nerve /opt/synapse}.each do |old_dir|
  directory old_dir do
    action :delete
    recursive true
  end
end
