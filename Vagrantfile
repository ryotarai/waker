Vagrant.configure(2) do |config|

  config.vm.box = "centos-66-x64-puppet-vbox"

  config.vm.define "nagios" do |server|
    server.vm.hostname = "nagios.private"
    server.vm.network    "private_network", ip: "192.168.100.140"
    server.vm.provider "virtualbox" do |config|
      config.cpus   = 2
      config.memory = 2048
      config.customize [
        "modifyvm", :id,
        "--hwvirtex", "on",
        "--nestedpaging", "on",
        "--largepages", "on",
        "--ioapic", "on",
        "--pae", "on",
        "--paravirtprovider", "kvm",
      ]
    end
  end
  config.vm.define "host" do |server|
    server.vm.hostname = "host.private"
    server.vm.network    "private_network", ip: "192.168.100.141"
    server.vm.provider "virtualbox" do |config|
      config.cpus   = 1
      config.memory = 1024
      config.customize [
        "modifyvm", :id,
        "--hwvirtex", "on",
        "--nestedpaging", "on",
        "--largepages", "on",
        "--ioapic", "on",
        "--pae", "on",
        "--paravirtprovider", "kvm",
      ]
    end
  end
end
