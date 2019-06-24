require 'json'
require 'getoptlong'

nodes = JSON.parse(File.read('nodes.json'), object_class: OpenStruct)
#puts nodes
#exit

Vagrant.configure(2) do |config|

   nodes.each do |node|

      config.vm.define node[:name] do |guest|

         guest.vm.box = node[:box]
         guest.vm.hostname = node[:name]

         guest.vm.provider 'virtualbox' do |vb|

            guest.vm.network 'private_network', ip: node[:ip], :netmask => node[:netmask], auto_config: true

            vb.name = node[:name]
            vb.memory = node[:memory]
            vb.cpus = node[:cpus]

            guest.vm.provision "ansible_local" do |ansible|

               ansible.playbook = node[:playbook]
               ansible.extra_vars = { node_ip: node[:ip] }

            end

         end

      end

   end

end
