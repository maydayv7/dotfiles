{
  lib,
  pkgs,
  ...
}: {
  ## Security & Hardening Settings ##
  config = {
    # Protocols
    programs.firejail.enable = true;
    security = {
      protectKernelImage = false; # To enable Hibernation
      apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
        packages = [pkgs.apparmor-profiles];
      };
    };

    boot = {
      # Parameters
      kernelParams = ["page_alloc.shuffle=1" "page_poison=1" "slub_debug=FZP"];

      # Flags
      kernel.sysctl = {
        # Kernel
        "kernel.ftrace_enabled" = false;
        "kernel.kexec_load_disabled" = true;
        "kernel.kptr_restrict" = lib.mkOverride 500 2;
        "kernel.sysrq" = 0;
        "kernel.yama.ptrace_scope" = lib.mkOverride 500 1;

        # Network
        "net.core.bpf_jit_enable" = true;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.conf.all.accept_redirects" = false;
        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv4.conf.all.log_martians" = true;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.all.secure_redirects" = false;
        "net.ipv4.conf.all.send_redirects" = false;
        "net.ipv4.conf.default.accept_redirects" = false;
        "net.ipv4.conf.default.log_martians" = true;
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.default.secure_redirects" = false;
        "net.ipv4.conf.default.send_redirects" = false;
        "net.ipv4.icmp_echo_ignore_broadcasts" = true;
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_rfc1337" = 1;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv6.conf.all.accept_redirects" = false;
        "net.ipv6.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.default.accept_redirects" = false;
      };

      # Secure Modules
      kernelModules = ["tcp_bbr"];

      # Old & Obscure Modules
      blacklistedKernelModules = [
        # Network Protocols
        "ax25"
        "netrom"
        "rose"

        # Filesystems
        "adfs"
        "affs"
        "befs"
        "bfs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "f2fs"
        "freevxfs"
        "hfs"
        "hpfs"
        "jfs"
        "minix"
        "nilfs2"
        "ntfs"
        "omfs"
        "qnx4"
        "qnx6"
        "sysv"
        "ufs"
      ];
    };

    ## Block Junk Sites
    networking.extraHosts =
      builtins.readFile (pkgs.fetchurl {
        # Shady Sites
        url = "https://raw.githubusercontent.com/shreyasminocha/shady-hosts/a5647df22b0dc5ff6c866f21ee2d8b588682626a/hosts";
        sha256 = "sha256-f6xCphzFHFYfOhMv+488amAMy+rSyHxQs/21nyvBtiU=";
      })
      + builtins.readFile (pkgs.fetchurl {
        # Crypto Scams
        url = "https://raw.githubusercontent.com/MetaMask/eth-phishing-detect/78e727318a77fd62521d220e25871cdb65b8f00d/src/hosts.txt";
        sha256 = "sha256-b3HvaLxnUJZOANUL/p+XPNvu9Aod9YLHYYtCZT5Lan0=";
      });
  };
}
