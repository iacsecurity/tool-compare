This case is a bit special - there's a public ACL on the bucket, but there's also
a public access block. Therefore, the ACL does not apply. This is a case where an IaC security
tool can take the access block into account, and silence any alerts about the ACL.