#!/bin/bash
set -e

instance_id=$(curl -s 169.254.169.254/latest/meta-data/instance-id)
private_ip=$(curl -s 169.254.169.254/latest/meta-data/local-ipv4)

node_instance_ids=$(aws --region ${region} \
  elb describe-load-balancers \
  --load-balancer-names ${elb_name} | \
  jq -r '.LoadBalancerDescriptions[0].Instances[].InstanceId')

node_private_ips=$(aws --region ${region} \
   ec2 describe-instances \
   --instance-ids $node_instance_ids | \
   jq -r '.Reservations | map(.Instances[].PrivateIpAddress)')

data_dir="/data"
config_dir="/etc/consul.d"

mkdir -p "$data_dir"
mkdir -p "$config_dir"

cat << EOF > "$config_dir/config.json"
{
  "datacenter": "${datacenter}",
  "server": true,
  "bootstrap_expect": ${node_count},
  "data_dir": "$data_dir",
  "node_name": "$instance_id",
  "bind_addr": "$private_ip",
  "client_addr": "0.0.0.0",
  "leave_on_terminate": true,
  "rejoin_after_leave": true,
  "retry_join": $node_private_ips,
  "ui": true
}
EOF

initctl restart consul
