default.smartstack.ports = {
  # reserved for health checks on synapse itself
  # TODO: implement health checks on synapse
  3210 => 'synapse',
  # reserved for a possible UI for nerve
  3211 => 'nerve',
  # reserved for the haproxy stats socket
  3212 => 'haproxy',
  3500 => 'echo',
}

# also create a mapping going the other way
default.smartstack.service_ports = Hash[node.smartstack.ports.collect {|k, v| [v, k]}]

# Port for synapse UI
# TODO: Incorporate all ports into node['smartstack']['ports'] and use erb templating
# to dynamically be able to open whatever ports desired
default.haproxy.port.ui = 3212
