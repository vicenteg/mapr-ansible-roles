Vagrant.configure("2") do |config|
  disk_size = 16 * 1024
  memory = (5 * 1024).round
  config.vm.define "node1" do |node1|
  
    node1.vm.box = "centos65"
    node1.vm.hostname = "node1"
    node1.vm.network :forwarded_port, guest: 8443, host: 8443

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    node1.vm.network :private_network, ip: "192.168.33.11"
    node1.vm.provider :virtualbox do |provider|
      provider.name = "mapr_singlenode"
      disk_path = "/Users/vince/Virtualbox VMs/%s" % provider.name
      disk_filenames = [ 'mapr_disk1.vdi', 'mapr_disk2.vdi', 'mapr_disk3.vdi' ]

      provider.customize ["modifyvm", :id, "--memory", memory]
      disk_filenames.each_with_index do |disk_file, port|
        path = "%s/%s" % [disk_path, disk_file]
        unless File.exist?(path)
          provider.customize ['createhd', '--filename', path, '--size', disk_size]
        end
        provider.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', port+1, '--device', 0, '--type', 'hdd', '--medium', path]
      end
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.host_key_checking = false
    #ansible.verbose = "vvvv" 
    ansible.playbook = "playbooks/bootstrap.yml"
  end
end
