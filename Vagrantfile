Vagrant::Config.run do |config|
  config.vm.box       = 'precise32'
  config.vm.box_url   = 'http://files.vagrantup.com/precise32.box'
  config.vm.host_name = 'rails-dev'
  config.vm.network :hostonly, "10.10.10.10"
  #config.vm.network :bridged

  config.vm.forward_port 3000, 3000
  config.vm.forward_port 4321, 4321
  config.vm.forward_port 5432, 5432

  config.vm.share_folder 'code', '/home/vagrant/code', '~/Code', :nfs => true

  config.vm.provision :puppet,
    :manifests_path => 'puppet/manifests',
    :module_path    => 'puppet/modules'
end
