let
  # Encryption
  cryptuiPkg = pkgs:
    pkgs.libcryptui.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.wrapGAppsHook3];
    });

  # Previewer
  previewPkg = pkgs:
    pkgs.sushi.overrideAttrs (old: {
      postPatch =
        old.postPatch
        + ''
          substituteInPlace src/ui/application.js \
            --replace-fail 'this._skeleton2.export(connection, actualPath);' ${pkgs.lib.escapeShellArg ''
            this._skeleton2.export(connection, actualPath);
            this._nemoSkeleton = Gio.DBusExportedObject.wrapJSObject(
                '<node><interface name="org.nemo.Preview">' +
                '<method name="ShowFile">' +
                '<arg type="s" direction="in" name="uri"/>' +
                '<arg type="i" direction="in" name="xid"/>' +
                '<arg type="b" direction="in" name="closeIfAlreadyShown"/>' +
                '</method><method name="Close"/></interface></node>', {
                    ShowFile: (uri, xid, closeIfAlreadyShown) =>
                        this.showFile(uri, "", closeIfAlreadyShown),
                    Close: () => this.close(),
                });
            this._nemoSkeleton.export(connection, '/org/nemo/Preview');
            this._nemoName = Gio.bus_own_name_on_connection(
                connection, 'org.nemo.Preview', Gio.BusNameOwnerFlags.NONE, null, null);
          ''} \
            --replace-fail 'this._skeleton2.unexport(connection);' ${pkgs.lib.escapeShellArg ''
            this._nemoSkeleton.unexport();
            Gio.bus_unown_name(this._nemoName);
            this._skeleton2.unexport(connection);
          ''}

          substituteInPlace src/ui/mainWindow.js \
            --replace-fail 'Sushi.window_set_child_of_external(this, handle);' \
              'if (handle) Sushi.window_set_child_of_external(this, handle);'
        '';

      postInstall =
        old.postInstall
        + ''
          cat > "$out/share/dbus-1/services/org.nemo.Preview.service" <<EOF
          [D-BUS Service]
          Name=org.nemo.Preview
          Exec=$out/libexec/org.gnome.NautilusPreviewer
          EOF
        '';
    });

  nemoPkg = pkgs:
    pkgs.nemo-with-extensions.override {
      extensions = [
        (previewPkg pkgs)
        ((pkgs.nemo-seahorse.override {
            libcryptui = cryptuiPkg pkgs;
          })
          .overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.wrapGAppsHook3];
          }))
      ];
    };
in {
  inherit cryptuiPkg nemoPkg;
}
