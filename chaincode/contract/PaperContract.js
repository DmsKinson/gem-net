/*
SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Fabric smart contract classes
const Contract  = require('fabric-contract-api');

// GemNet specifc classes
const Gem = require('./Gem.js');
const GemContext = require('./PaperContext.js')

/**
 * Define commercial paper smart contract by extending Fabric Contract class
 *
 */
class GemContract extends Contract {

    constructor() {
        // Unique namespace when multiple contracts per chaincode file
        super('org.gemnet.gem');
    }

    /**
     * Define a custom context for commercial paper
    */
    createContext() {
        return new GemContext();
    }

    // /**
    //  * Instantiate to perform any setup of the ledger that might be required.
    //  * @param {Context} ctx the transaction context
    //  */
    // async instantiate(ctx) {
    //     // No implementation required with this example
    //     // It could be where data migration is performed, if necessary
    //     // eslint-disable-next-line no-console
    //     console.log('Instantiate the contract');
    // }



    /**
     * Produce gem
     *
     * @param {Context} ctx the transaction context
     * @param {String} producer the producer of gem
     * @param {String} gemID Identity of Gem
     * @param {String} produceDate time gem was produced
     * @param {String} owner current owner of gem
     * @param {String} lastTransactionDate time gem was transacted
     * @param {String} gemCert the certificate of gem
     * @param {Integer} currentValue the current value of gem
     */
    async produce(ctx, producer, gemID, produceDate, owner, lastTransactionDate, gemCert, currentValue) {

        // create an instance of the paper
        let gem = Gem.createInstance(producer, gemID, produceDate, owner,lastTransactionDate, gemCert, currentValue);

        // Smart contract, rather than paper, moves paper into ISSUED state
        gem.setProduced();

        // Newly issued paper is owned by the issuer
        // paper.setOwner(issuer);

        // Add the paper to the list of all similar commercial papers in the ledger world state
        await ctx.gemList.addGem(gem);

        // Must return a serialized paper to caller of smart contract
        return gem.toBuffer();
    }

    /**
     * Buy gem
     * @param {Context} ctx the transaction context
     * @param {String} producer producer of gem
     * @param {String} gemID Identity of gem
     * @param {String} buyer who buy the gem
     * @param {String} seller who seller the gem
     * @param {String} purchaseDate time when transaction happen
     * @param {Integer} price price buyer paid
     */
    async buy(ctx, producer, gemID, buyer, seller, purchaseDate, price) {

        // Retrieve the current paper using key fields provided
        let gemKey = Gem.makeKey([producer, gemID]);
        let gem = await ctx.gemList.getGem(gemKey);

        // Validate current owner
        if (gem.getOwner() !== seller) {
            throw new Error('Gem ' + producer + gemID + ' is not owned by ' + seller);
        }

        // First buy moves state from ISSUED to TRADING
        if (gem.isProduced()) {
            gem.setTrading();
        }

        // Check paper is not already REDEEMED
        if (gem.isTrading()) {
            gem.setOwner(buyer);
            gem.setLastTransactionDate(purchaseDate);
            gem.setCurrentValue(price);
        } else {
            throw new Error('Gem ' + producer + gemID + ' is not trading. Current state = ' + gem.getCurrentState());
        }

        // Update the paper
        await ctx.gemList.updateGem(gem);
        return gem.toBuffer();
    }


    async accredit(ctx, producer, gemID, gemCert) {

        let gemKey = Gem.makeKey([producer, gemID]);

        let gem = await ctx.paperList.getPaper(gemKey);

        // Check paper is not PRODUCED
        if (gem.isProduced()) {
            gem.setCert(gemCert);
        }else{
            throw new Error('Gem ' + producer + gemID + ' already produced');
        }

        await ctx.paperList.updatePaper(gem);
        return gem.toBuffer();
    }

}

module.exports = GemContract;
