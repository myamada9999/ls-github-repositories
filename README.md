
ls-github-repositories
======================

ls-github-repositories prints all name of public git repositories under https://github.com/${USER}/.

This is a simple bash script.

How to use?
-----------

Please install curl command, because ls-gh-repos uses curl command for github api.

	$ sudo apt-get install curl

Then, change directory and run ls-gh-repos.sh with ${USER}.

	$ cd ls-github-repositories
    $ ./ls-gh-repos.sh ${USER}

${USER} is a account name of github which you want to search.

Notes
-----

Don't use this script so many times.

If you exceed rate limit, this script maybe return 403 forbidden temporarily.

If so, please wait a moment to use this script.

