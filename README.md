# dune-testpypi

upload packages action
----------------------

This action can be run manually to upload packages to
a package index (currently `pypi`, `testpypi`, or `none` for simply testing).
Packaging is done by running the `testing scenario` action on
`dune-project/dune-testpypi`. The actual running of the tests there (done
every night anyway) can be disabled in the workflow input fields.
The installed system packages are also obtained from
`dune-project/dune-testpypi` by downloading the `ossetup` file from there.

The server to use to download the packages can be specified in the `input`
field, currently `gitlab (dune)`, `github (adedner)`, or `lund` are
available.

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

sync and tag mirrors action
---------------------------

This workflow first mirrors the duen gitlab repositories to github (under adedner).
Tags added to the github repos are preserved. The most recent commit in the
provided branch (master by default) is tagged with the tag provided in the
input field. The special name `automatic` (default) can be used to provide
an automatic tag which is currently a combination of the version number
extracted from `dune-common/dune.module` followed by `dev` and today's
date, i.e., a pre-release version is created.

In a second step the `upload packages` workflow is started passing on the
relevant parameters from the workflow input field, e.g., the upload
location. The download location is always `github`. If this step fails
then the newly created tag is replaced with same tag but with a prepended
`failed-` to make it easy to checkout the failed version but also to reuse
the tag for a new upload attempt.
