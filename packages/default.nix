# Default Package Channel
with builtins; (getFlake "git+file://${toString ../.}").legacyPackages."${currentSystem}"
