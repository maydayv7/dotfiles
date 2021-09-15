"use strict";
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
/* exported ScrollManager */
const GLib = imports.gi.GLib;

var ScrollManager = class ScrollManager {
    /**
     * @param {Gtk.ScrolledWindow} gtkScrolledWindow
     */
    constructor(gtkScrolledWindow) {
        this._gtkScrolledWindow = gtkScrolledWindow;

        this._scrollUp = false;
        this._scrollDown = false;
    }

    startScrollUp() {
        // If the scroll up is already started, don't do anything.
        if (this._scrollUp) return;

        // Make sure scroll down is stopped.
        this.stopScrollDown();

        this._scrollUp = true;

        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 200, () => {
            // Set the new vadjustment value to either the current value minus a
            // step increment or to 0.
            const newVAdjustementValue = Math.max(this._gtkScrolledWindow.vadjustment.get_value() - this._gtkScrolledWindow.vadjustment.get_step_increment(), 0);

            // If the new value is the old one, return and stop this interval.
            if (newVAdjustementValue === this._gtkScrolledWindow.vadjustment.get_value()) {
                this._scrollUp = false;
                return this._scrollUp;
            }
            // Otherwise, update the value.
            this._gtkScrolledWindow.vadjustment.set_value(newVAdjustementValue);
            return this._scrollUp;
        });
    }

    startScrollDown() {
        // If the scroll down is already started, don't do anything.
        if (this._scrollDown) return;

        // Make sure scroll up is stopped.
        this.stopScrollUp();

        this._scrollDown = true;

        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 200, () => {
            // Set the new vadjusment value either to the curent value plus a
            // step increment or to the upper value minus the page size.
            const newVAdjustementValue = Math.min(
                this._gtkScrolledWindow.vadjustment.get_value() + this._gtkScrolledWindow.vadjustment.get_step_increment(),
                this._gtkScrolledWindow.vadjustment.get_upper() - this._gtkScrolledWindow.vadjustment.get_page_size()
            );

            // If the new value is the old one, return and stop this interval.
            if (newVAdjustementValue === this._gtkScrolledWindow.vadjustment.get_value()) {
                this._scrollDown = false;
                return this._scrollDown;
            }
            // Otherwise, update the value.
            this._gtkScrolledWindow.vadjustment.set_value(newVAdjustementValue);
            return this._scrollDown;
        });
    }

    stopScrollUp() {
        this._scrollUp = false;
    }

    stopScrollDown() {
        this._scrollDown = false;
    }

    stopScrollAll() {
        this.stopScrollUp();
        this.stopScrollDown();
    }
};
