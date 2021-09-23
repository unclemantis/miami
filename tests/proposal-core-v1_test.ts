
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
//import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that <...>",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let wallet_1 = accounts.get('wallet_1')!;
        let wallet_2 = accounts.get('wallet_2')!;
        let wallet_3 = accounts.get('wallet_3')!;
        let wallet_4 = accounts.get('wallet_4')!;
        let block = chain.mineBlock([
            Tx.contractCall('member', 'create-member',[types.utf8("Unclemantis"), types.utf8("image.gif"), types.utf8("Unclemantis@email.com")], wallet_1.address),
            Tx.contractCall('member', 'create-member',[types.utf8("Rollymaduk"), types.utf8("image.gif"), types.utf8("rollymaduk@email.com")], wallet_2.address),
            Tx.contractCall('member', 'create-member',[types.utf8("looser"), types.utf8("image.gif"), types.utf8("rollymaduk@email.com")], wallet_3.address),
            Tx.contractCall('member', 'create-member',[types.utf8("killer"), types.utf8("image.gif"), types.utf8("rollymaduk@email.com")], wallet_4.address),
            Tx.contractCall('proposal-core-v1', 'create-proposal',[types.utf8("Proposal 1"), types.utf8("fds s  er wersdf sdf sdf dsf ds"), types.utf8("This is only a test"), types.uint(2100)], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'create-proposal',[types.utf8("Proposal 2"), types.utf8("fds s  er wersdf sdf sdf dsf ds"), types.utf8("This is only a test"), types.uint(2100)], wallet_2.address),
            Tx.contractCall('proposal-core-v1', 'create-proposal',[types.utf8("Proposal 2"), types.utf8("fds s  er wersdf sdf sdf dsf ds"), types.utf8("This is only a test"), types.uint(2100)], wallet_3.address),
            Tx.contractCall('proposal-core-v1', 'create-proposal',[types.utf8("Proposal 2"), types.utf8("fds s  er wersdf sdf sdf dsf ds"), types.utf8("This is only a test"), types.uint(2100)], wallet_4.address),
            Tx.contractCall('proposal-core-v1', 'get-proposals',[], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'cast-ballot',[types.int(1), types.bool(true)], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'cast-ballot',[types.int(2), types.bool(false)], wallet_2.address),
            Tx.contractCall('proposal-core-v1', 'get-members',[], wallet_1.address),
            Tx.contractCall('proposal-core-v1', 'get-full-proposal',[types.int(1)], wallet_1.address),
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
        console.log(block.receipts[10].result);
        console.log(block.receipts[11].result);
        console.log(block.receipts[12].result);
    },
});
