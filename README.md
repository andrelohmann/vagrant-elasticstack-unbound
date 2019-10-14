# vagrant-elasticstack-unbound

(c) Andre Lohmann (and others) 2019

## Maintainer Contact
 * Andre Lohmann
   <lohmann.andre (at) gmail (dot) com>

## content

Vagrant template, to deploy an elasticstack (elasticsearch + kibana + beats) test stack together with an unbound machine, shipping logs to elasticsearch.

## Usage

### Configuration

Copy the config.yml.example to config.yml and alternate as you need it.

Copy ansible_vagrant/custom_vars.yml.example to ansible_vagrant/custom_vars.yml and alternate as you need it.

### Run

```
vagrant up
```

The Vagrantfile installs two machines. One (server) is equipped with elasticsearch and kibana, while the other (client) is equipped with beats, shipping metrics to the server.

```
vagrant ssh server
```

```
vagrant ssh client
```

Elasticsearch will be listening on the server public ip on port 9200.

```
curl -i http://SERVER.DOMAIN:9200
```

Kibana will be listening on the server public ip on port 5601.

```
http://SERVER.DOMAIN:5601
```
