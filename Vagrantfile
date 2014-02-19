Vagrant.configure("2") do |config|
  disk_size = 8 * 1024 * 1024
  memory = (5 * 1024).round

  config.vm.define "node1" do |node1|
    node1.vm.box = "centos65"
    node1.vm.hostname = "node1"
    node1.vm.network :forwarded_port, guest: 8443, host: 8443

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    node1.vm.network :private_network, ip: "192.168.33.11"
    node1.vm.provider :virtualbox do |provider|
      provider.customize ["modifyvm", :id, "--memory", memory]
      disk_file = "./tmp/mapr_node1_disk.vdi"
      unless File.exist?(disk_file)
        provider.customize ['createhd', '--filename', disk_file, '--size', disk_size]
      end
      provider.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk_file]
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.host_key_checking = false
    #ansible.verbose = "vvvv" 
    ansible.playbook = "playbooks/bootstrap.yml"
  end
end
