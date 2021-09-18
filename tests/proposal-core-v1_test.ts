
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
//import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that <...>",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let wallet_1 = accounts.get('wallet_1')!;
        let wallet_2 = accounts.get('wallet_2')!;
        let wallet_3 = accounts.get('wallet_3')!;
        let block = chain.mineBlock([
            Tx.contractCall('proposal-core-v1', 'create-proposal',[types.utf8("Proposal 1"), types.utf8("This is only a test"), types.uint(2100)], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'get-proposal-ids',[], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'get-proposals',[], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'get-proposal',[types.int(1)], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'get-full-proposal',[types.int(1)], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'cast-ballot',[types.int(1), types.bool(true)], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'cast-ballot',[types.int(1), types.bool(true)], wallet_2.address),
            Tx.contractCall('proposal-core-v1', 'cast-ballot',[types.int(1), types.bool(false)], wallet_3.address),
            Tx.contractCall('proposal-core-v1', 'get-yes-ballots',[types.int(1)], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'get-no-ballots',[types.int(1)], wallet_1.address),
        ]);
        console.log(block.receipts[0].result);
        console.log(block.receipts[1].result);
        console.log(block.receipts[2].result);
        console.log(block.receipts[3].result);
        console.log(block.receipts[4].result);
        console.log(block.receipts[5].result);
        console.log(block.receipts[6].result);
        console.log(block.receipts[7].result);
        console.log(block.receipts[8].result);
        console.log(block.receipts[9].result);
    },
});
