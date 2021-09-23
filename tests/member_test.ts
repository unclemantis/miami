
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.15.4/index.ts';
//import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that <...>",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let wallet_1 = accounts.get('wallet_1')!;
        let wallet_2 = accounts.get('wallet_2')!;
        let wallet_3 = accounts.get('wallet_3')!;
        let block = chain.mineBlock([
            /* 
             * Add transactions with: 
             * Tx.contractCall(...)
            */
        ]);
        //console.log(block.receipts[0].result);
        //console.log(block.receipts[1].result);
    },
});
