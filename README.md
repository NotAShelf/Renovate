# 🏠 Renovate

> A cozy commons library for an unified configuration interface.

## What am I looking at?

Renovate is a NixOS module that aims to replace my out-of-place abstractions within my configuration, which usually go something like
`options.modules.programs.<program>.enable = mkEnableOption "program"`, which seems to be a common abstraction used by plenty of NixOS users.

Renovate exposes **one** interface, which ~~defines~~ tries to define all programs in once place:

```nix
options.renovate.programs = {
    # a list of mail clients that we want to make available
    mail = {
        thunderbird = mkEnableOption "Thunderbird mail client";
        kmail = mkEnableOption "Kmail mail client";
    };

    # a list of various messenger apps that we would like available
    messenger = {
        discord = mkEnableOption "Discord messenger";
        hexchat = mkEnableOption "Hexchat IRC client";
    };

    # other applications...
};
```

This interface is then used in various condition checks, so that you may enable programs conditionally
from (ideally) a single file.

```nix
# configuration.nix
imports = [ inputs.renovate.nixosModules.default]; # import renovate module

config = {
    renovate.programs = {
        messenger.discord.enable = true;
        mail.thunderbird.enable = true;
    };
}
```

The enable state of the program is then used in any other configuration file, ranging from
NixOS modules to Home-manager (Hm).

```nix
# someHmModule.nix
{osConfig, lib, ...}: let
    osConfig.renovate.programs.mail.thunderbird
in; {
    config = lib.mkIf (cfg.enable) {
        # this is home-manager's own programs.thunderbird
        programs.thunderbird = {
            enable = true;
            someAttrset = {
                key = value;
            };
        };

        xdg.configFile."someFile.conf".text = ''
            # some testing config
        '';
    };
}
```

## Cool, what problem does it solve?

Renovate's purpose is simple: to define conditions from a single interface, so that the system is _fully_ self aware.
Using a singular configuration file, be it per host or globally shared, you can easily enable specific modules within your configuration depending on the enable status of programs.

## Todo

- Extend the scope of this project. Instead of just defining enable options, allow for configuration set options.
- Flake checks and tests
- More examples
- Relocate my system abstractions to here

## Contributing

All contributions are welcome. I will probably not be able to add all programs myself, but if you find this project interesting and decide it is missing a program that you use, feel free to PR or request a module for it.

## License

See [License](License).
