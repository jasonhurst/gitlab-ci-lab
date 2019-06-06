# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#

servers=[
  {
    :hostname => "gitlab",
    :ip => "192.168.100.10",
    :box => "bento/centos-7.3",
    :ram => 2048,
    :cpu => 2,
    :hport => 8082,
    :gport => 8080
  },
  {
    :hostname => "gitlab-runner",
    :ip => "192.168.100.11",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8083,
    :gport => 8081
  }
]


Vagrant.configure(2) do |config|
    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network "private_network", ip: machine[:ip]
            node.vm.network "forwarded_port", host: machine[:hport], guest: machine[:gport]
              node.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
                vb.customize ["modifyvm", :id, "--cpus", machine[:cpu]]
              end
              node.vm.provision "shell",
              path: machine[:hostname] + ".sh",
              env: {"USERNAME"=>ENV['DI2E_USERNAME'], "PASSWORD"=>ENV['DI2E_PASSWORD']}
        end
    end
end
