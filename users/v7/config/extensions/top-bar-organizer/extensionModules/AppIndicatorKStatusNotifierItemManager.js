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
/* exported AppIndicatorKStatusNotifierItemManager */
"use strict";

var AppIndicatorKStatusNotifierItemManager = class AppIndicatorKStatusNotifierItemManager {
    constructor() {
        // Create an application-role map for associating roles with
        // applications.
        // This is needed so that this class can handle/manage
        // AppIndicator/KStatusNotifierItem items.
        this._applicationRoleMap = new Map();
    }

    /**
     * Handle an AppIndicator/KStatusNotifierItem item.
     *
     * This function basically does the following two things:
     * - Associate the role of the given item with the application of the
     *   AppIndicator/KStatusNotifierItem.
     * - Add a placeholder for the roles associated with the application of the
     *   AppIndiciator/KStatusNotifierItem to the box order, if needed.
     *
     * Note: The caller is responsible for saving the updated box order to
     * settings.
     * @param {} indicatorContainer - The container of the indicator of the
     * AppIndicator/KStatusNotifierItem item.
     * @param {string} role - The role of the AppIndicator/KStatusNotifierItem
     * item.
     * @param {string[]} - The box order the placeholder should be added to, if
     * needed.
     * @param {BoxOrders} boxOrders - An object containing the box orders, which
     * is currently getting worked on.
     * @param {boolean} - Whether to add the placeholder to the beginning of the
     * box order.
     */
    handleAppIndicatorKStatusNotifierItemItem(indicatorContainer, role, boxOrder, boxOrders, atToBeginning = false) {
        // Get the application the AppIndicator/KStatusNotifierItem is
        // associated with.
        const application = indicatorContainer.get_child()._indicator.id;

        // Associate the role with the application.
        let roles = this._applicationRoleMap.get(application);
        if (roles) {
            // If the application already has an array of associated roles, just
            // add the role to it, if needed.
            if (!roles.includes(role)) roles.push(role);
        } else {
            // Otherwise create a new array.
            this._applicationRoleMap.set(application, [ role ]);
        }

        // Store a placeholder for the roles associated with the application in
        // the box order, if needed.
        // (Then later the `this.createResolvedBoxOrder` method can be used to
        // get a box order, where the placeholder/s get/s replaced with the
        // relevant roles (by using `this._applicationRoleMap`).)
        const placeholder = `appindicator-kstatusnotifieritem-${application}`;
        if (!boxOrders.left.includes(placeholder)
            && !boxOrders.center.includes(placeholder)
            && !boxOrders.right.includes(placeholder)) {
            if (atToBeginning) {
                boxOrder.unshift(placeholder);
            } else {
                boxOrder.push(placeholder);
            }
        }
    }

    /**
     * This function takes a box order and returns a box order, where all
     * placeholders got replaced with their relevant roles.
     * @param {string[]} boxOrder - The box order of which to replace the
     * placeholders.
     * @returns {string[]} A resolved box order, where all placeholders got
     * replaced with their relevant roles.
     */
    createResolvedBoxOrder(boxOrder) {
        let resolvedBoxOrder = [ ];
        for (const item of boxOrder) {
            // If the item isn't a placeholder, just add it to the new resolved
            // box order.
            if (!item.startsWith("appindicator-kstatusnotifieritem-")) {
                resolvedBoxOrder.push(item);
                continue;
            }

            /// If the item is a placeholder, replace it.
            // First get the application this placeholder is associated with.
            const application = item.replace("appindicator-kstatusnotifieritem-", "");

            // Then get the roles associated with the application.
            let roles = this._applicationRoleMap.get(application);

            // Continue, if there are no roles.
            if (!roles) continue;
            // Otherwise add the roles
            for (const role of roles) {
                resolvedBoxOrder.push(role);
            }
        }

        return resolvedBoxOrder;
    }
};
