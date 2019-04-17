/*
SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Fabric smart contract classes
const Context = require('fabric-contract-api');

const GemList = require('./GemList.js');

/**
 * A custom context provides easy access to list of all commercial papers
 */
class GemContext extends Context {

    constructor() {
        super();
        // All papers are held in a list of papers
        this.gemList = new GemList(this);
    }

}

module.exports = GemContext;
