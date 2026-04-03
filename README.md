# machine-config

---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo systemctl restart nix-daemon.service

to start the nix-daemon.service

Alright! We're done!
Try it! Open a new terminal, and type:

  $ nix-shell -p nix-info --run "nix-info -m"

Thank you for using this installer. If you have any feedback or need
help, don't hesitate:

You can open an issue at
https://github.com/NixOS/nix/issues/new?labels=installer&template=installer.md

Or get in touch with the community: https://nixos.org/community

---- Reminders -----------------------------------------------------------------
[ 1 ]
Nix won't work in active shell sessions until you restart them.

==> Ensuring flakes are enabled
==> Restarting nix-daemon
==> Applying Home Manager config
warning: creating lock file "/home/set/Documents/machine-config/nix/flake.lock": 
• Added input 'home-manager':
    'github:nix-community/home-manager/d166a078541982a76f14d3e06e9665fa5c9ed85e?narHash=sha256-S0RqAyDPMTcv9vASMaE8eY1QexFysAOdnxUxFHIPOyE%3D' (2026-04-02)
• Added input 'home-manager/nixpkgs':
    follows 'nixpkgs'
• Added input 'nixpkgs':
    'github:NixOS/nixpkgs/6201e203d09599479a3b3450ed24fa81537ebc4e?narHash=sha256-ZojAnPuCdy657PbTq5V0Y%2BAHKhZAIwSIT2cb8UgAz/U%3D' (2026-04-01)
error: flake 'git+file:///home/set/Documents/machine-config?dir=nix' does not provide attribute 'packages.x86_64-linux.homeConfigurations."set".activationPackage', 'legacyPackages.x86_64-linux.homeConfigurations."set".activationPackage' or 'homeConfigurations."set".activationPackage'
       Did you mean Set?

