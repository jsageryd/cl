# CL
Generates change log from version tags (vX.Y.Z) and lines beginning with "cl: "
in commit messages.

## Usage example
Right before release of v1.0:

    ./cl.rb v1.0 > CHANGES.md
