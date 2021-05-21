One of the best practices when making containers available through AWS ECR
is to have all tags be immutable - once a container is published, another image
cannot assume the same tag.

This test case simulates a case where this best practice is _not_ followed.