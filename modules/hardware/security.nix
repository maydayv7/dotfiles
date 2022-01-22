{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOverride;
  enable = config.hardware.security;
in rec {
  options.hardware.security =
    mkEnableOption "Enable Additional Security and Hardening Settings";

  ## Security Settings ##
  config = lib.mkIf enable {
    warnings = [(''
      Additional Security Settings are enabled
      - These may cause instability issues or sacrifice performance
      - Proceed with Caution
    '')];

    # Protocols
    security = {
      # Kernel
      lockKernelModules = true;
      protectKernelImage = true;

      # Apps
      apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
      };
    };

    boot = {
      # Parameters
      kernelParams =
        [ "page_alloc.shuffle=1" "page_poison=1" "slub_debug=FZP" ];

      # Flags
      kernel.sysctl = {
        # Kernel
        "kernel.ftrace_enabled" = false;
        "kernel.kptr_restrict" = mkOverride 500 2;
        "kernel.sysrq" = 0;
        "kernel.yama.ptrace_scope" = mkOverride 500 1;

        # Network
        "net.core.bpf_jit_enable" = false;
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
      kernelModules = [ "tcp_bbr" ];

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
  };
}
