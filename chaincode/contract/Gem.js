/*
SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for ledger state
const State = require('./lib/State.js');

// Enumerate commercial paper state values
const cpState = {
    PRODUCED: 1,
    TRADING: 2,
    POSSESSED: 3
};


/**
 * GemPaper class extends State class
 * Class will be used by application and smart contract to define a paper
 */
class Gem extends State {

    constructor(obj) {
        super(Gem.getClass(), [obj.producer, obj.gemID]);
        Object.assign(this, obj);
    }

    // /**
    //  * Basic getters and setters
    // */

    // getProducer() {
    //     return this.producer;
    // }

    // setProducer(newProducer) {
    //     this.issuer = newProducer;
    // }

    setLastTransactionDate(lastTransactionDate) {
        this.lastTransactionDate = lastTransactionDate;
    }

    setCurrentValue(currentValue) {
        this.currentValue = currentValue;
    }

    setCert(gemCert) {
        this.gemCert = gemCert;
    }

    getOwner() {
        return this.owner;
    }

    setOwner(newOwner) {
        this.owner = newOwner;
    }

    /**
     * Useful methods to encapsulate gem states
     */
    setProduced() {
        this.currentState = cpState.PRODUCED;
    }

    setTrading() {
        this.currentState = cpState.TRADING;
    }

    setPossessed() {
        this.currentState = cpState.POSSESSED;
    }

    isProduced() {
        return this.currentState === cpState.PRODUCED;
    }

    isTrading() {
        return this.currentState === cpState.TRADING;
    }

    isPossessed() {
        return this.currentState === cpState.POSSESSED;
    }

    static fromBuffer(buffer) {
        return Gem.deserialize(Buffer.from(JSON.parse(buffer)));
    }

    toBuffer() {
        return Buffer.from(JSON.stringify(this));
    }

    /**
     * Deserialize a state data to commercial paper
     * @param {Buffer} data to form back into the object
     */
    static deserialize(data) {
        return State.deserializeClass(data, Gem);
    }

    /**
     * Factory method to create a commercial paper object
     */
    static createInstance(producer, gemID, owner, produceDate, lastTransactionDate, gemCert, currentValue) {
        return new Gem({ producer, gemID, owner, produceDate, lastTransactionDate, gemCert, currentValue });
    }

    static getClass() {
        return 'org.gemnet.gem';
    }
}

module.exports = Gem;
