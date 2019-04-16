/*
SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for collections of ledger states --  a state list
const StateList = require('./lib/stateList.js');

const GemPaper = require('./paper.js');

class PaperList extends StateList {

    constructor(ctx) {
        super(ctx, 'org.gemnet.gempaperlist');
        this.use(GemPaper);
    }

    async addPaper(paper) {
        return this.addState(paper);
    }

    async getPaper(paperKey) {
        return this.getState(paperKey);
    }

    async updatePaper(paper) {
        return this.updateState(paper);
    }
}


module.exports = PaperList;