require 'json'
require 'getoptlong'

nodes = JSON.parse(File.read('nodes.json'), object_class: OpenStruct)
#puts nodes
#exit

Vagrant.configure(2) do |config|

   nodes.each do |node|

      config.vm.define node[:name] do |config|
        config.vm.box = node[:box]
        config.vm.hostname = node[:name]
        config.vm.network 'private_network', ip: node[:ip], :netmask => node[:netmask], auto_config: true
        config.vm.provider "virtualbox" do |vb|
           vb.name = node[:name]
           vb.memory = node[:memory]
           vb.cpus = node[:cpus]
        end
        config.vm.provision "ansible_local" do |ansible|
           ansible.playbook = node[:playbook]
           ansible.extra_vars = { node_ip: node[:ip] }
        end
      end

   end

end
