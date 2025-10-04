# Replace with your actual NACL id from step 1
locals {
  private_nacl_id = "acl-08864158084fd5e93"
}

# Allow ALL outbound from private subnets (to NAT -> Internet)
resource "aws_network_acl_rule" "priv_out_all" {
  network_acl_id = local.private_nacl_id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Allow return traffic (ephemeral TCP) back IN to the private subnets
resource "aws_network_acl_rule" "priv_in_ephemeral" {
  network_acl_id = local.private_nacl_id
  rule_number    = 110
  egress         = false
  protocol       = "6"        # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}
