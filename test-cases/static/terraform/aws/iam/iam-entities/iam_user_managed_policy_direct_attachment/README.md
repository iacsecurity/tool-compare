One of the best practices when managing IAM in AWS is not to attach a policy
directly to a user, rather attach it to the group the user belongs to.

This test case simulates a case where this best practice is _not_ followed.