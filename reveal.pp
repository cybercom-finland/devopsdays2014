package { 'nginx':
        ensure  => installed,
        }

package { 'apache2':
        ensure  => absent,
        }

service { 'nginx':
    ensure  => 'running',
    enable  => 'true',
    require => Package['nginx'],
        }

file { '/etc/nginx/sites-enabled/default':
        ensure => absent,
        }

file { '/etc/nginx/conf.d/presentation.conf':
        notify  => Service['nginx'],
        ensure  => present,
        mode    => 0644,
        content => "server {
        listen 80 default_server;
        root /usr/local/devopsdays/presentation;
        access_log /var/log/nginx/access.log;
        index index.html;
        }\n"
        }
