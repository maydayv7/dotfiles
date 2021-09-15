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
/* exported buildPrefsWidget, init */
"use strict";

const Gtk = imports.gi.Gtk;
const GObject = imports.gi.GObject;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

const PrefsBoxOrderListEmptyPlaceholder = Me.imports.prefsModules.PrefsBoxOrderListEmptyPlaceholder;
const PrefsBoxOrderItemRow = Me.imports.prefsModules.PrefsBoxOrderItemRow;

var PrefsWidget = GObject.registerClass({
    GTypeName: "PrefsWidget",
    Template: Me.dir.get_child("prefs-widget.ui").get_uri(),
    InternalChildren: [
        "left-box-order",
        "center-box-order",
        "right-box-order"
    ]
}, class PrefsWidget extends Gtk.Box {
    _init(params = {}) {
        super._init(params);

        this._settings = ExtensionUtils.getSettings();

        // Initialize the given `gtkListBox`.
        const initializeGtkListBox = (boxOrder, gtkListBox) => {
            // Add the items of the given configured box order as
            // GtkListBoxRows.
            for (const item of boxOrder) {
                const listBoxRow = new PrefsBoxOrderItemRow.PrefsBoxOrderItemRow();

                listBoxRow.item = item;
                if (item.startsWith("appindicator-kstatusnotifieritem-")) {
                    // Set `item_name_display_label` of the `listBoxRow` to
                    // something nicer, if the associated item is an
                    // AppIndicator/KStatusNotifierItem item.
                    listBoxRow.item_name_display_label.set_label(item.replace("appindicator-kstatusnotifieritem-", ""));
                } else {
                    // Otherwise just set the `item_name_display_label` of the
                    // `listBoxRow` to `item`.
                    listBoxRow.item_name_display_label.set_label(item);
                }
                gtkListBox.append(listBoxRow);
            }

            // Add a placeholder widget for the case, where `gtkListBox` doesn't
            // have any GtkListBoxRows.
            gtkListBox.set_placeholder(new PrefsBoxOrderListEmptyPlaceholder.PrefsBoxOrderListEmptyPlaceholder());
        };

        initializeGtkListBox(this._settings.get_strv("left-box-order"), this._left_box_order);
        initializeGtkListBox(this._settings.get_strv("center-box-order"), this._center_box_order);
        initializeGtkListBox(this._settings.get_strv("right-box-order"), this._right_box_order);

        // Set the box order each GtkListBox is associated with.
        // This is needed by the reordering of the GtkListBoxRows, so that the
        // updated box orders can be saved.
        this._left_box_order.boxOrder = "left-box-order";
        this._center_box_order.boxOrder = "center-box-order";
        this._right_box_order.boxOrder = "right-box-order";
    }
});

function buildPrefsWidget() {
    return new PrefsWidget();
}

function init() {
}
