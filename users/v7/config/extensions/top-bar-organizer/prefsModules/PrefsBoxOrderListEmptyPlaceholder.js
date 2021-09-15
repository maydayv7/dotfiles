/*
 * This file is part of Top-Bar-Organizer (a Gnome Shell Extension for
 * organizing your Gnome Shell top bar).
 * Copyright (C) 2021 Julian Schacher
 *
 * Top-Bar-Organizer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
/* exported PrefsBoxOrderListEmptyPlaceholder */
"use strict";

const Gtk = imports.gi.Gtk;
const Gdk = imports.gi.Gdk;
const GObject = imports.gi.GObject;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

var PrefsBoxOrderListEmptyPlaceholder = GObject.registerClass({
    GTypeName: "PrefsBoxOrderListEmptyPlaceholder",
    Template: Me.dir.get_child("prefs-box-order-list-empty-placeholder.ui").get_uri()
}, class PrefsBoxOrderListEmptyPlaceholder extends Gtk.Box {
    _init(params = {}) {
        super._init(params);

        /// Make `this` accept drops by creating a drop target and adding it to
        /// `this`.
        let dropTarget = new Gtk.DropTarget();
        dropTarget.set_gtypes([GObject.type_from_name("PrefsBoxOrderItemRow")]);
        dropTarget.set_actions(Gdk.DragAction.MOVE);
        // Handle a new drop on `this` properly.
        // `value` is the thing getting dropped.
        dropTarget.connect("drop", (target, value) => {
            // Get the GtkListBoxes of `this` and the drop value.
            const ownListBox = this.get_parent();
            const valueListBox = value.get_parent();

            // Remove the drop value from its list box.
            valueListBox.remove(value);

            // Insert the drop value into the list box of `this`.
            ownListBox.insert(value, 0);

            /// Finally save the box orders to settings.
            const settings = ExtensionUtils.getSettings();

            settings.set_strv(ownListBox.boxOrder, [value.item]);

            let updatedBoxOrder = [ ];
            for (let potentialListBoxRow of valueListBox) {
                // Only process PrefsBoxOrderItemRows.
                if (potentialListBoxRow.constructor.$gtype.name !== "PrefsBoxOrderItemRow") {
                    continue;
                }

                const item = potentialListBoxRow.item;
                updatedBoxOrder.push(item);
            }
            settings.set_strv(valueListBox.boxOrder, updatedBoxOrder);
        });
        this.add_controller(dropTarget);
    }
});
