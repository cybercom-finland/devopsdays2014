package { "rsyslog":
        ensure => present,
}

service { "rsyslog":
        ensure => running,
        require => Package["rsyslog"],
}

        file { "/etc/rsyslog.d/17-nginx.conf":
                ensure => present,
                content => "\$ModLoad imfile
\$InputFileName /var/log/nginx/access.log 
\$InputFileTag nginx-access:
\$InputFileStateFile state-nginx-access
\$InputRunFileMonitor
\$InputFileName /var/log/nginx/error.log
\$InputFileTag nginx-error:
\$InputFileStateFile state-nginx-error
\$InputRunFileMonitor\n",
                require => Package["rsyslog"],
                notify => Service["rsyslog"],
}
