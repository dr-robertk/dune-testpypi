# dune-testpypi

"upload packages" action
-------------------------

This action can be run manually to upload packages to
a package index (currently `pypi` and `testpypi`).
Packaging is done by running the `testing scenario` action on
`dune-project/dune-testpypi`. The actual running of the tests there (done
every night anyway) can be disabled in the workflow input fields.
The installed system packages are also obtained from
`dune-project/dune-testpypi` by downloading the `ossetup` file from there.

This action uses the `dune-fem` tutorial to test the packages before upload.
The 'tag' to use can be different for core and dune-fem modules) can be set as
parameters. Instead of a 'tag' it is also possible to provide a branch
name but then uploading is disabled.

__Note__: for a new version tag, i.e., without a `-devX` ending the tag has to exists for all modules of the given class
(core or dune-fem) otherwise it is not possible to upload the packages (running without an upload is possible).
This is to avoid inconsistent package versions where one module is ahead of the others.
It is possible to upload post-releases for individual modules; before upload these will be tested with the available versions
on `pypi`.

__Note__: it is not possible to overwrite an existing package on either `pypi` or `testpypi`. This actions first checks if
a requested version already exists on the upload package index and if so the dune module will not be cloned but will be
downloaded from the index (and no upload is attempted).
