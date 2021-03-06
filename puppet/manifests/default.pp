$user = 'vagrant'
$home = '/home/vagrant'

# Make sure apt-get -y update runs before anything else.
stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { '/usr/bin/apt-get -y update':
    user => 'root'
  }
}

class { 'apt_get_update':
  stage => preinstall
}

class install_sqlite3 {
  package { 'sqlite3':
    ensure => installed;
  }

  package { 'libsqlite3-dev':
    ensure => installed;
  }
}
class { 'install_sqlite3': }

class install_mysql {
  class { 'mysql': }

  class { 'mysql::server':
    config_hash => { 'root_password' => '' }
  }


  package { 'libmysqlclient15-dev':
    ensure => installed
  }
}

class install_qt4 {
	package { 'libqt4-dev':
		ensure => installed;
	}
}

class { 'install_qt4': }

class { 'install_mysql': }

class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server':
	listen => ['*',],
	port => 5432,
	acl =>['host all all 10.0.2.2/32 trust', ],
  
  }

  pg_user { 'vagrant':
    ensure    => present,
    superuser => true,
    password  => 'vagrant',
    require   => Class['postgresql::server']
  }

  pg_database {'dc3_dev':
	  ensure   => present,
	  owner    => 'postgres',
  }

  pg_database {'dc3_test':
	  ensure   => present,
	  owner    => 'postgres',
  }
  package { 'libpq-dev':
    ensure => installed
  }
}
class { 'install_postgres': }

class install_core_packages {
  package { ['build-essential', 'vim', 'ruby1.9.3']:
    ensure => installed
  }
}
class { 'install_core_packages': }

class install_nokogiri_dependencies {
  package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
    ensure => installed
  }
}
class { 'install_nokogiri_dependencies': }

class install_rbenv {

  rbenv::install { 'vagrant':
    group => $user,
    home => $home
  }

  rbenv::compile { '1.9.3-p194':
    user => $user,
    home => $home
  }
}
class { 'install_rbenv': }

class setup_env {
  exec { "echo 'gem: --no-ri --no-rdoc' > /home/vagrant/.gemrc":
    user => $user,
    unless => "ls .gemrc",
    path => "${home}/bin:${home}/.rbenv/shims:/bin:/usr/bin"
  }
  # TODO dotfiles
  class { 'ohmyzsh': }
}
class { 'setup_env': }

#class { 'nodejs':
#  version => '0.8.8',
#}

class { 'memcached': }
