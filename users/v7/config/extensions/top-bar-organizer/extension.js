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
/* exported init */
"use strict";

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

const Main = imports.ui.main;
const Panel = imports.ui.panel;

const AppIndicatorKStatusNotifierItemManager = Me.imports.extensionModules.AppIndicatorKStatusNotifierItemManager;
const BoxOrderCreator = Me.imports.extensionModules.BoxOrderCreator;

class Extension {
    constructor() {
    }

    enable() {
        this.settings = ExtensionUtils.getSettings();

        // Create an instance of AppIndicatorKStatusNotifierItemManager to
        // handle AppIndicator/KStatusNotifierItem items.
        this._appIndicatorKStatusNotifierItemManager = new AppIndicatorKStatusNotifierItemManager.AppIndicatorKStatusNotifierItemManager();

        // Create an instance of BoxOrderCreator for the creation of special box
        // orders.
        this._boxOrderCreator = new BoxOrderCreator.BoxOrderCreator(this._appIndicatorKStatusNotifierItemManager);

        this._addNewItemsToBoxOrders();
        this._orderTopBarItemsOfAllBoxes();
        this._overwritePanelAddToPanelBox();

        // Handle changes of configured box orders.
        this._settingsHandlerIds = [ ];

        const addConfiguredBoxOrderChangeHandler = (box) => {
            let handlerId = this.settings.connect(`changed::${box}-box-order`, () => {
                this._orderTopBarItems(box);

                /// For the case, where the currently saved box order is based
                /// on a permutation of an outdated box order, get an updated
                /// box order and save it, if needed.
                let updatedBoxOrder;
                switch (box) {
                    case "left":
                        updatedBoxOrder = this._createUpdatedBoxOrders().left;
                        break;
                    case "center":
                        updatedBoxOrder = this._createUpdatedBoxOrders().center;
                        break;
                    case "right":
                        updatedBoxOrder = this._createUpdatedBoxOrders().right;
                        break;
                }
                // Only save the updated box order to settings, if it is
                // different, to avoid looping.
                const currentBoxOrder = this.settings.get_strv(`${box}-box-order`);
                if (JSON.stringify(currentBoxOrder) !== JSON.stringify(updatedBoxOrder)) {
                    this.settings.set_strv(`${box}-box-order`, updatedBoxOrder);
                }
            });
            this._settingsHandlerIds.push(handlerId);
        };

        addConfiguredBoxOrderChangeHandler("left");
        addConfiguredBoxOrderChangeHandler("center");
        addConfiguredBoxOrderChangeHandler("right");
    }

    disable() {
        // Revert the overwrite of `Panel._addToPanelBox`.
        Panel.Panel.prototype._addToPanelBox = Panel.Panel.prototype._originalAddToPanelBox;
        // Set `Panel._originalAddToPanelBox` to `undefined`.
        Panel._originalAddToPanelBox = undefined;

        // Disconnect signals.
        for (const handlerId of this._settingsHandlerIds) {
            this.settings.disconnect(handlerId);
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    /// Methods used on extension enable.                                    ///
    ////////////////////////////////////////////////////////////////////////////

    /**
     * This method adds all new items currently present in the Gnome Shell top
     * bar to the box orders.
     */
    _addNewItemsToBoxOrders() {
        const boxOrders = this._createUpdatedBoxOrders();
        this.settings.set_strv("left-box-order", boxOrders.left);
        this.settings.set_strv("center-box-order", boxOrders.center);
        this.settings.set_strv("right-box-order", boxOrders.right);
    }

    /**
     * This methods orders the top bar items of all boxes according to the
     * configured box orders using `this._orderTopBarItems`.
     */
    _orderTopBarItemsOfAllBoxes() {
        this._orderTopBarItems("left");
        this._orderTopBarItems("center");
        this._orderTopBarItems("right");
    }

    /**
     * An object containing a position and box overwrite.
     * @typedef PositionAndBoxOverwrite
     * @property {Number} position - The position overwrite.
     * @property {string} box - The position box overwrite.
     */

    /**
     * Overwrite `Panel._addToPanelBox` with a custom method, which handles top
     * bar item additions to make sure that they are added in the correct
     * position and box.
     */
    _overwritePanelAddToPanelBox() {
        // Add the original `Panel._addToPanelBox` method as
        // `Panel._originalAddToPanelBox`.
        Panel.Panel.prototype._originalAddToPanelBox = Panel.Panel.prototype._addToPanelBox;

        // This function gets used by the `Panel._addToPanelBox` overwrite to
        // determine the position and box for a new item.
        // It also adds the new item to the relevant box order, if it isn't in
        // it already.
        const getPositionAndBoxOverwrite = (role, box, indicator) => {
            const boxOrders = {
                left: this.settings.get_strv("left-box-order"),
                center: this.settings.get_strv("center-box-order"),
                right: this.settings.get_strv("right-box-order"),
            };
            let boxOrder;

            // Handle the case where the new item is a
            // AppIndicator/KStatusNotifierItem.
            if (role.startsWith("appindicator-")) {
                switch (box) {
                    case "left":
                        boxOrder = this.settings.get_strv("left-box-order");
                        this._appIndicatorKStatusNotifierItemManager.handleAppIndicatorKStatusNotifierItemItem(indicator.container, role, boxOrder, boxOrders);
                        this.settings.set_strv("left-box-order", boxOrder);
                        break;
                    case "center":
                        boxOrder = this.settings.get_strv("center-box-order");
                        this._appIndicatorKStatusNotifierItemManager.handleAppIndicatorKStatusNotifierItemItem(indicator.container, role, boxOrder, boxOrders);
                        this.settings.set_strv("center-box-order", boxOrder);
                        break;
                    case "right":
                        boxOrder = this.settings.get_strv("right-box-order");
                        this._appIndicatorKStatusNotifierItemManager.handleAppIndicatorKStatusNotifierItemItem(indicator.container, role, boxOrder, boxOrders, true);
                        this.settings.set_strv("right-box-order", boxOrder);
                        break;
                }
            }

            // Get the resolved box orders for all boxes.
            const resolvedBoxOrders = {
                left: this._appIndicatorKStatusNotifierItemManager.createResolvedBoxOrder(this.settings.get_strv("left-box-order")),
                center: this._appIndicatorKStatusNotifierItemManager.createResolvedBoxOrder(this.settings.get_strv("center-box-order")),
                right: this._appIndicatorKStatusNotifierItemManager.createResolvedBoxOrder(this.settings.get_strv("right-box-order")),
            };
            // Also get the restricted valid box order of the target box.
            const restrictedValidBoxOrderOfTargetBox = this._boxOrderCreator.createRestrictedValidBoxOrder(box);

            // Get the index of the role for each box order.
            const indices = {
                left: resolvedBoxOrders.left.indexOf(role),
                center: resolvedBoxOrders.center.indexOf(role),
                right: resolvedBoxOrders.right.indexOf(role),
            };

            // If the role is not already configured in one of the box orders,
            // just add it to the target box order at the end/beginning, save
            // the updated box order and return the relevant position and box.
            if (indices.left === -1
                && indices.center === -1
                && indices.right === -1) {
                switch (box) {
                    // For the left and center box, insert the role at the end,
                    // since they're LTR.
                    case "left":
                        boxOrders["left"].push(role);
                        this.settings.set_strv("left-box-order", boxOrders["left"]);
                        return {
                            position: restrictedValidBoxOrderOfTargetBox.length - 1,
                            box: box
                        };
                    case "center":
                        boxOrders["center"].push(role);
                        this.settings.set_strv("center-box-order", boxOrders["center"]);
                        return {
                            position: restrictedValidBoxOrderOfTargetBox.length - 1,
                            box: box
                        };
                    // For the right box, insert the role at the beginning,
                    // since it's RTL.
                    case "right":
                        boxOrders["right"].unshift(role);
                        this.settings.set_strv("right-box-order", boxOrders["right"]);
                        return {
                            position: 0,
                            box: box
                        };
                }
            }

            /// Since the role is already configured in one of the box orders,
            /// determine the correct insertion index for the position.
            const determineInsertionIndex = (index, restrictedValidBoxOrder, boxOrder) => {
                // Set the insertion index initially to 0, so that if no closest
                // item can be found, the new item just gets inserted at the
                // beginning.
                let insertionIndex = 0;

                // Find the index of the closest item, which is also in the
                // valid box order and before the new item.
                // This way, we can insert the new item just after the index of
                // this closest item.
                for (let i = index - 1; i >= 0; i--) {
                    let potentialClosestItemIndex = restrictedValidBoxOrder.indexOf(boxOrder[i]);
                    if (potentialClosestItemIndex !== -1) {
                        insertionIndex = potentialClosestItemIndex + 1;
                        break;
                    }
                }

                return insertionIndex;
            };

            if (indices.left !== -1) {
                return {
                    position: determineInsertionIndex(indices.left, this._boxOrderCreator.createRestrictedValidBoxOrder("left"), resolvedBoxOrders.left),
                    box: "left"
                };
            }

            if (indices.center !== -1) {
                return {
                    position: determineInsertionIndex(indices.center, this._boxOrderCreator.createRestrictedValidBoxOrder("center"), resolvedBoxOrders.center),
                    box: "center"
                };
            }

            if (indices.right !== -1) {
                return {
                    position: determineInsertionIndex(indices.right, this._boxOrderCreator.createRestrictedValidBoxOrder("right"), resolvedBoxOrders.right),
                    box: "right"
                };
            }
        };

        // Overwrite `Panel._addToPanelBox`.
        Panel.Panel.prototype._addToPanelBox = function (role, indicator, position, box) {
            // Get the position and box overwrite.
            let positionBoxOverwrite;
            switch (box) {
                case this._leftBox:
                    positionBoxOverwrite = getPositionAndBoxOverwrite(role, "left", indicator);
                    break;
                case this._centerBox:
                    positionBoxOverwrite = getPositionAndBoxOverwrite(role, "center", indicator);
                    break;
                case this._rightBox:
                    positionBoxOverwrite = getPositionAndBoxOverwrite(role, "right", indicator);
                    break;
            }

            // Call the original `Panel._addToPanelBox` with the position
            // overwrite as the position argument and the box determined by the
            // box overwrite as the box argument.
            switch (positionBoxOverwrite.box) {
                case "left":
                    this._originalAddToPanelBox(role, indicator, positionBoxOverwrite.position, Main.panel._leftBox);
                    break;
                case "center":
                    this._originalAddToPanelBox(role, indicator, positionBoxOverwrite.position, Main.panel._centerBox);
                    break;
                case "right":
                    this._originalAddToPanelBox(role, indicator, positionBoxOverwrite.position, Main.panel._rightBox);
                    break;
            }
        };
    }

    ////////////////////////////////////////////////////////////////////////////
    /// Helper methods holding logic needed by other methods.                ///
    ////////////////////////////////////////////////////////////////////////////

    /**
     * An object containing a box order for the left, center and right top bar
     * box.
     * @typedef {Object} BoxOrders
     * @property {string[]} left - The box order for the left top bar box.
     * @property {string[]} center - The box order for the center top bar box.
     * @property {string[]} right - The box order for the right top bar box.
     */

    /**
     * This method adds all new items currently present in the Gnome Shell top
     * bar to the correct box order and returns the new box orders.
     * @returns {BoxOrders} - The updated box orders.
     */
    _createUpdatedBoxOrders() {
        // Load the configured box orders from settings.
        const boxOrders = {
            left: this.settings.get_strv("left-box-order"),
            center: this.settings.get_strv("center-box-order"),
            right: this.settings.get_strv("right-box-order"),
        };

        // Get items (or rather their roles) currently present in the Gnome
        // Shell top bar and index them using their associated indicator
        // container.
        let indicatorContainerRoleMap = new Map();
        for (const role in Main.panel.statusArea) {
            indicatorContainerRoleMap.set(Main.panel.statusArea[role].container, role);
        }

        // Get the indicator containers (of the items) currently present in the
        // Gnome Shell top bar boxes.
        const boxOrderIndicatorContainers = {
            left: Main.panel._leftBox.get_children(),
            center: Main.panel._centerBox.get_children(),
            // Reverse this array, since the items in the left and center box
            // are logically LTR, while the items in the right box are RTL.
            right: Main.panel._rightBox.get_children().reverse()
        };

        // This function goes through the items (or rather their indicator
        // containers) of the given box and adds new items (or rather their
        // roles) to the box order.
        const addNewItemsToBoxOrder = (boxIndicatorContainers, boxOrder, box) => {
            for (const indicatorContainer of boxIndicatorContainers) {
                // First get the role associated with the current indicator
                // container.
                const associatedRole = indicatorContainerRoleMap.get(indicatorContainer);

                // Handle an AppIndicator/KStatusNotifierItem item differently.
                if (associatedRole.startsWith("appindicator-")) {
                    this._appIndicatorKStatusNotifierItemManager.handleAppIndicatorKStatusNotifierItemItem(indicatorContainer, associatedRole, boxOrder, boxOrders, box === "right");
                    continue;
                }

                // Add the role to the box order, if it isn't in in one already.
                if (!boxOrders.left.includes(associatedRole)
                    && !boxOrders.center.includes(associatedRole)
                    && !boxOrders.right.includes(associatedRole)) {
                    if (box === "right") {
                        // Add the items to the beginning for this array, since
                        // its RTL.
                        boxOrder.unshift(associatedRole);
                    } else {
                        boxOrder.push(associatedRole);
                    }
                }
            }
        };

        addNewItemsToBoxOrder(boxOrderIndicatorContainers.left, boxOrders.left, "left");
        addNewItemsToBoxOrder(boxOrderIndicatorContainers.center, boxOrders.center, "center");
        addNewItemsToBoxOrder(boxOrderIndicatorContainers.right, boxOrders.right, "right");

        return boxOrders;
    }

    /**
     * This method orders the top bar items of the specified box according to
     * the configured box orders.
     * @param {string} box - The box to order.
     */
    _orderTopBarItems(box) {
        // Get the valid box order.
        const validBoxOrder = this._boxOrderCreator.createValidBoxOrder(box);

        // Get the relevant box of `Main.panel`.
        let panelBox;
        switch (box) {
            case "left":
                panelBox = Main.panel._leftBox;
                break;
            case "center":
                panelBox = Main.panel._centerBox;
                break;
            case "right":
                panelBox = Main.panel._rightBox;
                break;
        }

        /// Go through the items (or rather their roles) of the validBoxOrder
        /// and order the panelBox accordingly.
        for (let i = 0; i < validBoxOrder.length; i++) {
            const role = validBoxOrder[i];
            // Get the indicator container associated with the current role.
            const associatedIndicatorContainer = Main.panel.statusArea[role].container;

            associatedIndicatorContainer.get_parent().remove_child(associatedIndicatorContainer);
            panelBox.insert_child_at_index(associatedIndicatorContainer, i);
        }
        // To handle the case, where the box order got set to a permutation
        // of an outdated box order, it would be wise, if the caller updated the
        // box order now to include the items present in the top bar.
    }
}

function init() {
    return new Extension();
}
