ansible-logstash role
=====================

[logstash](http://http://logstash.net/) is a tool for managing events and logs. You can use it to collect logs, parse them, and store them for later use (like, for searching).

Requirements
------------
tested on Ubuntu 12.04 but should work with most *nix that support init.d or supervisor and java 

Role Variables
--------------

All variables default variable are defined in defaults/main.yml

### Version
Version is defined with major and minor. The 1.3 version is not supported

	logstash_version_major  : "1.4"
	logstash_version_minor  : "2"

### Startup variables
logstash can start with either initd or supervisor

	logstash_start_stop     : "initd" 

### Directory setup
	logstash_base_dir       : "/opt/logstash"

if your using version 1.4.2 a directory will be created with the version number and a source directory for tar.gz files

	logstash_log_dir        : "/var/log/logstash"	

logstash log please note that log rotate is not used within this playbook; So you have to use external role if you want to maintain it.

### Indexer conf from a file or template

You can deploy as much indexers as you want. Say you have 2 files both with input, filters and output, indexer_conf will deploy both files but will append a number 0-, 1- this will give priority to logstash of config file. 

To enable 
	
	indexer_conf_install    : True

provide an array with name and source path of your config. The order is important 

	indexer_conf :
                   - name: nginx.conf
                     src : /somepath/nginx_logstash.j2
                   - name: rsyslog.conf
                     src : /somepath/rsyslog_logstash.j2                     

An example config is provided in templates directory

### Indexer conf from a variable 
You can deploy logstash input, filter and output configuration from variables. The generated output will be z-variable.conf this will have the least precedence. This should be you fall back log plan to dump somewhere for you to analyze and see why it did not match your rules.

To enable

	indexer_conf_var_install : true

Input 
	
	indexer_conf_var_input   : |
	    tcp { 
	        port => 9124
	    }    

Filter

	indexer_conf_var_filter :  |

	    if [type] == "default_tcp" {
	        mutate {
	            add_field => { "source" => "MSG was sent by %{host} to tcp" }
	            add_tag => [ "matched" ]
	        }
	    }
Output 

	indexer_conf_var_output :  |
	    if "matched" in [tags] and "default_tcp" in [type]{
	        file { path => "/tmp/logstash_default_tcp_9124_match_ok.txt" }
	    } 
	    else if "matched" not in [tags] and "_grokparsefailure" not in [tags] {
	        file { path => "/tmp/logstash_all_others.txt" }
	    } 

### Clear etc directory
Some times you have old conf and want to clear the conf directory you can run the playbook with **-e logstash_clear_config=true** This will delete the config dir and recreate the conf

### Plugins extra grok patterns
if you want to deploy extra pattern files 

	extra_patterns_install  : True

Provide an array with name and source path of your gork pattern file
	extra_patterns  :
                       - name: nginx
                         src : nginx.grok

### Credits
Original code comes from https://github.com/valentinogagliardi/ansible-logstash

Adham Helal https://github.com/ahelal/

## TODO:
* More patterns
* logstash- forwarder
