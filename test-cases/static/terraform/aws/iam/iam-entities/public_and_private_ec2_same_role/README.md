One of the best practices when managing IAM in AWS is to ensure separation of
roles. Different compute resources should not share roles, as modifying one
may give unintended permissions to another. This is especially true if one resource
is public and the other is private.

This test case simulates a case where this best practice is _not_ followed.