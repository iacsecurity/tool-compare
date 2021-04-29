package example

import input as tfplan

matches_resource(x, resource) {
	x.name == resource.name
	x.type == resource.type
}

array_contains(arr, elem) {
  arr[_] = elem
}

denied_action = "0.0.0.0/0"

deny[reason] {
  resource := tfplan.planned_values.root_module.resources[_]
  resource.type == "aws_db_instance"

  resource.values.publicly_accessible

  sg_id = {x | tfplan.configuration.root_modules.resources[x]; true}[_].expressions.vpc_security_group_ids.references[_]

  sgs = {x | tfplan.planned_values.root_module.resources[x]; x.name = sg_id}
  r = sgs[_].ingress[_].cidr_blocks

  reason := sg_id

  reason = resource.name
}
