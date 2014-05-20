require 'etc'
username = Etc.getlogin

Vagrant.configure("2") do |config|
  disk_size = 16 * 1024
  memory = (8 * 1024).round
  config.vm.define "node1" do |node1|
  
    node1.vm.box = "centos65"
    node1.vm.hostname = "node1"
    node1.vm.network :forwarded_port, guest: 111, host: 111
    node1.vm.network :forwarded_port, guest: 2049, host: 2049
    node1.vm.network :forwarded_port, guest: 8443, host: 8443
    node1.vm.network :forwarded_port, guest: 8000, host: 8000
    #node1.vm.network :private_network, type: "dhcp"
    node1.vm.network :private_network, :ip =>'192.168.59.0', :auto_network => true, :type => "dhcp" 

    node1.vm.provider :virtualbox do |provider|
      provider.name = "mapr_singlenode"
      disk_path = "/Users/%s/Virtualbox VMs/%s" % [ username, provider.name ]
      disk_filenames = (1..6).map{|n| "mapr_disk%s.vdi" % n }

      provider.customize ["modifyvm", :id, "--memory", memory]
      disk_filenames.each_with_index do |disk_file, index|
        port = index+1
        path = "%s/%s" % [disk_path, disk_file]
        unless File.exist?(path)
          provider.customize ['createhd', '--filename', path, '--size', disk_size]
        end
        provider.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', port, '--device', 0, '--type', 'hdd', '--medium', path]
      end
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.inventory_path = 'hosts'
    ansible.host_key_checking = false
    #ansible.verbose = "vvvv" 
    ansible.playbook = "playbooks/install_cluster.yml"
  end
end
