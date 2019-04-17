/*
SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for collections of ledger states --  a state list
const StateList = require('./lib/StateList.js');

const Gem = require('./Gem.js');

class GemList extends StateList {

    constructor(ctx) {
        super(ctx, 'org.gemnet.gemlist');
        this.use(Gem);
    }

    async addGem(gem) {
        return this.addState(gem);
    }

    async getGem(gemKey) {
        return this.getState(gemKey);
    }

    async updateGem(gem) {
        return this.updateState(gem);
    }
}


module.exports = GemList;
