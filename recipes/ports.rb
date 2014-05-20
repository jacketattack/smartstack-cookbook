include_recipe 'iptables'

iptables_rule 'port_synapse' do
    source 'iptables/port_synapse.erb'
    action :enable
end
