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
/* exported BoxOrderCreator */
"use strict";

const ExtensionUtils = imports.misc.extensionUtils;

const Main = imports.ui.main;

/**
 * A class exposing methods, which create special box orders.
 */
var BoxOrderCreator = class BoxOrderCreator {
    /**
     * @param {AppIndicatorKStatusNotifierItemManager}
     * appIndicatorKStatusNotifierItemManager - An instance of
     * AppIndicatorKStatusNotifierItemManager to be used in the methods of
     * `this`.
     */
    constructor(appIndicatorKStatusNotifierItemManager) {
        this._appIndicatorKStatusNotifierItemManager = appIndicatorKStatusNotifierItemManager;

        this._settings = ExtensionUtils.getSettings();
    }

    /**
     * This function creates a valid box order for the given box.
     * This means it returns a box order for the box, where only roles are
     * included, which have their associated indicator container already in some
     * box of the Gnome Shell top bar.
     * @param {string} box - The box to return the valid box order for.
     * Must be one of the following values:
     * - "left"
     * - "center"
     * - "right"
     * @returns {string[]} - The valid box order.
     */
    createValidBoxOrder(box) {
        // Get a resolved box order.
        let boxOrder = this._appIndicatorKStatusNotifierItemManager.createResolvedBoxOrder(this._settings.get_strv(`${box}-box-order`));

        // Get the indicator containers (of the items) currently present in the
        // Gnome Shell top bar.
        const boxIndicatorContainers = [ ];

        const addIndicatorContainersOfBox = (panelBox) => {
            for (const indicatorContainer of panelBox.get_children()) {
                boxIndicatorContainers.push(indicatorContainer);
            }
        };

        addIndicatorContainersOfBox(Main.panel._leftBox);
        addIndicatorContainersOfBox(Main.panel._centerBox);
        addIndicatorContainersOfBox(Main.panel._rightBox);

        // Create an indicator containers set from the indicator containers for
        // fast easy access.
        const boxIndicatorContainersSet = new Set(boxIndicatorContainers);

        // Go through the box order and only add items to the valid box order,
        // where their indicator is present in the Gnome Shell top bar
        // currently.
        let validBoxOrder = [ ];
        for (const role of boxOrder) {
            // Get the indicator container associated with the current role.
            const associatedIndicatorContainer = Main.panel.statusArea[role]?.container;

            if (boxIndicatorContainersSet.has(associatedIndicatorContainer)) validBoxOrder.push(role);
        }

        return validBoxOrder;
    }

    /**
     * This function creates a restricted valid box order for the given box.
     * This means it returns a box order for the box, where only roles are
     * included, which have their associated indicator container already in the
     * specified box.
     * @param {string} box - The box to return the valid box order for.
     * Must be one of the following values:
     * - "left"
     * - "center"
     * - "right"
     * @returns {string[]} - The restricted valid box order.
     */
    createRestrictedValidBoxOrder(box) {
        // Get a resolved box order and get the indicator containers (of the
        // items) which are currently present in the Gnome Shell top bar in the
        // specified box.
        let boxOrder = this._appIndicatorKStatusNotifierItemManager.createResolvedBoxOrder(this._settings.get_strv(`${box}-box-order`));
        let boxIndicatorContainers;
        switch (box) {
            case "left":
                boxIndicatorContainers = Main.panel._leftBox.get_children();
                break;
            case "center":
                boxIndicatorContainers = Main.panel._centerBox.get_children();
                break;
            case "right":
                boxIndicatorContainers = Main.panel._rightBox.get_children();
                break;
        }

        // Create an indicator containers set from the indicator containers for
        // fast easy access.
        const boxIndicatorContainersSet = new Set(boxIndicatorContainers);

        // Go through the box order and only add items to the restricted valid
        // box order, where their indicator is present in the Gnome Shell top
        // bar in the specified box currently.
        let restrictedValidBoxOrder = [ ];
        for (const role of boxOrder) {
            // Get the indicator container associated with the current role.
            const associatedIndicatorContainer = Main.panel.statusArea[role]?.container;

            if (boxIndicatorContainersSet.has(associatedIndicatorContainer)) restrictedValidBoxOrder.push(role);
        }

        return restrictedValidBoxOrder;
    }
};
