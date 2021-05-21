One of the best practices when managing IAM in AWS is to focus on providing
each entity the least amount of privilege possible - only what is necessary.
The PassRole permission is a dangerous one and is best avoided, or limited with
conditions.

This test case simulates a case where this best practice is _not_ followed.