package { "rsyslog":
        ensure => present,
}

service { "rsyslog":
        ensure => running,
        require => Package["rsyslog"],
}

if $elkserverip {

        file { "/etc/rsyslog.d/15-logstash.conf":
                ensure => present,
                content => "\$ActionQueueFileName logstashfwdRule1
\$ActionQueueMaxDiskSpace 1g
\$ActionQueueSaveOnShutdown on
\$ActionQueueType LinkedList
\$ActionResumeRetryCount -1
*.* @${elkserverip}:5544",
                require => Package["rsyslog"],
                notify => Service["rsyslog"],
        }
}
