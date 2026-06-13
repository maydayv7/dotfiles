# https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa
{
  config,
  lib,
  ...
}: let
  configDir =
    {
      "vscode" = "Code";
      "vscode-insiders" = "Code - Insiders";
      "vscodium" = "VSCodium";
    }
    .${
      config.programs.vscode.package.pname
    };
  userDir = "${config.xdg.configHome}/${configDir}/User";

  configFilePath = "${userDir}/settings.json";
  tasksFilePath = "${userDir}/tasks.json";
  keybindingsFilePath = "${userDir}/keybindings.json";
  snippetDir = "${userDir}/snippets";

  cfg = config.programs.vscode.profiles.default;
  pathsToMakeWritable = lib.flatten [
    (lib.optional (cfg.userTasks != {}) tasksFilePath)
    (lib.optional (cfg.userSettings != {}) configFilePath)
    (lib.optional (cfg.keybindings != []) keybindingsFilePath)
    (lib.optional (cfg.globalSnippets != {}) "${snippetDir}/global.code-snippets")
    (lib.mapAttrsToList (language: _: "${snippetDir}/${language}.json") cfg.languageSnippets)
  ];
in {
  home.file = lib.genAttrs pathsToMakeWritable (_: {
    force = true;
    mutable = true;
  });
}
