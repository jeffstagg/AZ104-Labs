# -----------------------------
# Monkey patch File.exists? for modern Ruby/Vagrant
# -----------------------------
class File
  class << self
    alias_method :exists?, :exist? unless method_defined?(:exists?)
  end
end

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "azure-architect-lab"

  # -----------------------------
  # Shared folder for host <-> VM
  # -----------------------------
  config.vm.synced_folder ".", "/workspace",
    mount_options: ["dmode=775,fmode=664"]

  # -----------------------------
  # VirtualBox settings
  # -----------------------------
  config.vm.provider "virtualbox" do |vb|
    vb.name = "azure-architect-lab"
    vb.memory = 6144
    vb.cpus = 3
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # -----------------------------
  # Private network for hub-spoke / multi-node labs
  # -----------------------------
  config.vm.network "private_network", type: "dhcp"

  # -----------------------------
  # Provisioning: subscription detection + tool installation
  # -----------------------------
  config.vm.provision "shell", path: "bootstrap.sh"

end
