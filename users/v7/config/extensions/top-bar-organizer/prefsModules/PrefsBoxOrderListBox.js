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
/* exported PrefsBoxOrderListBox */
"use strict";

const Gtk = imports.gi.Gtk;
const GObject = imports.gi.GObject;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

var PrefsBoxOrderListBox = GObject.registerClass({
    GTypeName: "PrefsBoxOrderListBox",
    Template: Me.dir.get_child("prefs-box-order-list-box.ui").get_uri()
}, class PrefsBoxOrderListBox extends Gtk.ListBox {
    /**
     * @param {Object} params
     * @param {String} boxOrder - The box order this PrefsBoxOrderListBox is
     * associated with.
     */
    _init(params = {}, boxOrder) {
        super._init(params);

        this._settings = ExtensionUtils.getSettings();

        this.boxOrder = boxOrder;
    }

    /**
     * Saves the box order represented by `this` (and its
     * `PrefsBoxOrderItemRows`) to settings.
     */
    saveBoxOrderToSettings() {
        let currentBoxOrder = [ ];
        for (let potentialPrefsBoxOrderItemRow of this) {
            // Only process PrefsBoxOrderItemRows.
            if (potentialPrefsBoxOrderItemRow.constructor.$gtype.name !== "PrefsBoxOrderItemRow") continue;

            const item = potentialPrefsBoxOrderItemRow.item;
            currentBoxOrder.push(item);
        }
        this._settings.set_strv(this.boxOrder, currentBoxOrder);
    }
});
