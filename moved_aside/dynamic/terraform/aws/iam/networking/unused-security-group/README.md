# Unused Security Group

Determining if a security group is used or not requires looking at how the SG is used in the IaC code itself, as well as in the live cloud environment.
You may have a case of an SG that was created in IaC and isn't used anywhere,
or you may have a case where the SG was created in the cloud console (like a default SG) and it's not in use
by an IaC code or live resource.
