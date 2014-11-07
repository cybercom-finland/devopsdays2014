package { [ 'ruby-dev', 'git', 'build-essential' ]:
        ensure => 'present',
}

package { 'librarian-puppet':
        ensure   => 'installed',
        provider => 'gem',
        require => Package['ruby-dev'],
}

exec { 'init-librarian':
	environment => [ "HOME=/root", "USER=root" ],
        command => '/usr/local/bin/librarian-puppet init',
        cwd => '/etc/puppet',
        creates => '/etc/puppet/Puppetfile',
        require => [ Package['librarian-puppet'], Package['git'] ],
}

file { '/etc/puppet/Puppetfile':
        ensure => 'present',
        content => '#!/usr/bin/env ruby
                    forge "https://forgeapi.puppetlabs.com"
                    mod "puppetlabs-stdlib"
		    mod "puppetlabs-apache"
		    mod "puppetlabs-apt"
                    mod "puppet-elk",
                      :git => "https://github.com/cybercom-finland/puppet-elk.git"
                    mod "elasticsearch-logstash"
                    mod "elasticsearch-elasticsearch"',
        require => Exec['init-librarian'],
	notify => Exec['librarian-install-modules'],
}

exec { 'librarian-install-modules':
	environment => [ "HOME=/root", "USER=root" ],
        command => '/usr/local/bin/librarian-puppet install --verbose',
        cwd => '/etc/puppet',
	refreshonly => true,
        require => File['/etc/puppet/Puppetfile'],
}

