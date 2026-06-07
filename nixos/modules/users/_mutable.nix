# https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa
{ config, lib, ... }:
let
  inherit (builtins)
    attrValues
    concatLists
    filter
    foldl'
    map
    ;

  inherit (lib)
    assertMsg
    concatLines
    escapeShellArg
    getAttrFromPath
    hm
    mkOption
    recursiveUpdate
    setAttrByPath
    types
    ;

  fileOptionAttrPaths = [
    [
      "home"
      "file"
    ]
    [
      "xdg"
      "configFile"
    ]
    [
      "xdg"
      "dataFile"
    ]
  ];
in
{
  options =
    let
      mergeAttrsList = foldl' recursiveUpdate { };
      fileAttrsType = types.attrsOf (
        types.submodule (_: {
          options.mutable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to copy the file without the read-only attribute instead of
              symlinking. If you set this to `true`, you must also set `force` to
              `true`. Mutable files are not removed when you remove them from your
              configuration.
              This option is useful for programs that don't have a very good
              support for read-only configurations.
            '';
          };
        })
      );
    in
    mergeAttrsList (
      map (
        attrPath:
        setAttrByPath attrPath (mkOption {
          type = fileAttrsType;
        })
      ) fileOptionAttrPaths
    );

  config = {
    home.activation.mutableFileGeneration =
      let
        allFiles = concatLists (
          map (attrPath: attrValues (getAttrFromPath attrPath config)) fileOptionAttrPaths
        );

        filterMutableFiles = filter (
          file:
          (file.mutable or false)
          && assertMsg file.force "if you specify `mutable` to `true` on a file, you must also set `force` to `true`"
        );

        mutableFiles = filterMutableFiles allFiles;

        toCommand =
          file:
          let
            source = escapeShellArg file.source;
            target = escapeShellArg file.target;
          in
          ''
            $VERBOSE_ECHO "${source} -> ${target}"
            $DRY_RUN_CMD cp --remove-destination --no-preserve=mode ${source} ${target}
          '';

        command = ''
          echo "Copying mutable home files for $HOME"
        ''
        + concatLines (map toCommand mutableFiles);
      in
      hm.dag.entryAfter [ "linkGeneration" ] command;
  };
}
