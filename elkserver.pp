include elk

	file { '/etc/logstash/conf.d/41-nginx.conf':
	require	=> File['/etc/logstash/conf.d/10-syslog.conf'],
	ensure  => present,
        mode    => 0644,
        content => 'filter {
if [program] == "nginx-access" {

grok {
match => [ "message" , "%{IPORHOST:remote_addr} - %{USERNAME:remote_user} \[%{HTTPDATE:time_local}\] %{QS:request} %{INT:status} %{INT:body_bytes_sent} %{QS:http_referer} %{QS:http_user_agent}" ]

}

geoip {
source => "clientip"
target => "geoip"
database => "/opt/logstash/vendor/geoip/GeoLiteCity.dat"
add_field => [ "[geoip][coordinates]", "%{[geoip][longitude]}" ]
add_field => [ "[geoip][coordinates]", "%{[geoip][latitude]}"  ]
}

mutate {
convert => [ "[geoip][coordinates]", "float" ]
}

}
}
',
	notify	=> Service['logstash'],
	}
