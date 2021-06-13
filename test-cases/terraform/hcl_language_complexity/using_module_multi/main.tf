# In this case we're using a module and setting a password for one user,
# but not the other. For a tool to pass this test case it should alert a violation about
# only one of the two users. A tool that doesn't alert at all is considered a failure of the test.

module "jack" {
  source = "./mymodule"
  user_name = "jack"
  allow_password = true
  pgp_key = "keybase:some_key"
}

module "jill" {
  source = "./mymodule"
  user_name = "jill"
  allow_password = false
  pgp_key = "keybase:some_key"
}