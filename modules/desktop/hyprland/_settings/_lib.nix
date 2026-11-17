# Lua Config Helpers
lib: let
  inherit (lib) concatStringsSep;
  inline = lib.generators.mkLuaInline;
in rec {
  inherit inline;

  combo = mods: key:
    if mods == []
    then key
    else concatStringsSep " + " (mods ++ [key]);

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
  bind = keys: disp: {_args = [keys (inline disp)];};
  bindOpts = keys: disp: opts: {_args = [keys (inline disp) opts];};
  permission = re: type: act: {_args = [re type act];};
  on = event: fn: {_args = [event (inline fn)];};
  curve = name: spec: {_args = [name spec];};
}
