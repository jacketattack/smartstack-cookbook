include_attribute 'smartstack::ports'

# on chef-solo < 11.6, we hack around lack of environment support
# by using node.env because node.environment cannot be set
default.smartstack.env = (node.has_key?('env') ? node.env : node.environment)
#default.smartstack.env = "develop"

default.smartstack.services = {
    'synapse' => {},
    'nerve' => {},
    'haproxy' => {},
    'echo' => {
        'synapse' => {
            'discovery' => { 
                'method' => 'zookeeper',
                'path' => '/services/nerve/echo',        
            },
            'haproxy' => {
                 'port' => 3500 
            }  
        },
        'nerve' => {
            'host' => '127.0.0.1',
            'port' => 21567,
            'reporter_type' => 'zookeeper',
            'zk_path' => '/services/nerve/echo',
            'checks' => [
                {
                    'type' => 'tcp',
                }
            ]
        }
    }
}

# make sure each service has a smartstack config
default.smartstack.services.each do |name, service|
  # populate zk paths for all services
  unless service.has_key? 'zk_path'
    default.smartstack.services[name]['zk_path'] = "/#{node.smartstack.env}/services/#{name}/services"
  end

  # populate the local_port for all services
  port = node.smartstack.service_ports[name]
  if Integer === port
    service['local_port'] = port
  else
    Chef::Log.error "Service #{name} has no synapse port allocated; please see services/attributes/ports.rb"
    raise "Synapse port missing for #{name}"
  end
end
