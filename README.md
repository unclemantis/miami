# miami

+------------------------------------------------------------+-----------------------------------------------------------+
| Contract identifier                                        | Public functions                                          |
+------------------------------------------------------------+-----------------------------------------------------------+
| ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.member           | (create-member                                            |
|                                                            |     (name (string-utf8 50))                               |
|                                                            |     (imageUrl (string-utf8 50))                           |
|                                                            |     (email (string-utf8 50)))                             |
|                                                            | (does-member-exist)                                       |
|                                                            | (get-member (member-id principal))                        |
|                                                            | (get-member-ids)                                          |
|                                                            | (get-members)                                             |
+------------------------------------------------------------+-----------------------------------------------------------+
| ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-body    | (get-proposal-body (proposal-id int))                     |
|                                                            | (insert-body                                              |
|                                                            |     (proposal-id int)                                     |
|                                                            |     (body (string-utf8 3000)))                            |
+------------------------------------------------------------+-----------------------------------------------------------+
| ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-core-v1 | (cast-ballot                                              |
|                                                            |     (proposal-id int)                                     |
|                                                            |     (is-yes bool))                                        |
|                                                            | (create-proposal                                          |
|                                                            |     (title (string-utf8 50))                              |
|                                                            |     (summary (string-utf8 100))                           |
|                                                            |     (body (string-utf8 3000))                             |
|                                                            |     (duration uint))                                      |
|                                                            | (get-ballot-totals (proposal-id int))                     |
|                                                            | (get-closed-member-proposal-totals (member-id principal)) |
|                                                            | (get-closed-member-proposals (member-id principal))       |
|                                                            | (get-closed-proposal-totals)                              |
|                                                            | (get-closed-proposals)                                    |
|                                                            | (get-full-proposal (proposal-id int))                     |
|                                                            | (get-member (member-id principal))                        |
|                                                            | (get-member-proposal-ids (member-id principal))           |
|                                                            | (get-member-proposal-totals (member-id principal))        |
|                                                            | (get-member-proposals (member-id principal))              |
|                                                            | (get-members)                                             |
|                                                            | (get-no-ballot-totals (proposal-id int))                  |
|                                                            | (get-no-ballots (proposal-id int))                        |
|                                                            | (get-open-member-proposal-totals (member-id principal))   |
|                                                            | (get-open-member-proposals (member-id principal))         |
|                                                            | (get-open-proposal-totals)                                |
|                                                            | (get-open-proposals)                                      |
|                                                            | (get-proposal (proposal-id int))                          |
|                                                            | (get-proposal-ids)                                        |
|                                                            | (get-proposal-totals)                                     |
|                                                            | (get-proposals)                                           |
|                                                            | (get-yes-ballot-totals (proposal-id int))                 |
|                                                            | (get-yes-ballots (proposal-id int))                       |
+------------------------------------------------------------+-----------------------------------------------------------+

Initialized balances
+------------------------------------------------------+-----------------+
| Address                                              | STX             |
+------------------------------------------------------+-----------------+
| ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM (deployer) | 100000000000000 |
+------------------------------------------------------+-----------------+
| ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 (wallet_1) | 100000000000000 |
+------------------------------------------------------+-----------------+
| ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG (wallet_2) | 100000000000000 |
+------------------------------------------------------+-----------------+
| ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC (wallet_3) | 100000000000000 |
+------------------------------------------------------+-----------------+
| ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND (wallet_4)  | 100000000000000 |
+------------------------------------------------------+-----------------+
| ST2REHHS5J3CERCRBEPMGH7921Q6PYKAADT7JP2VB (wallet_5) | 100000000000000 |
+------------------------------------------------------+-----------------+
| ST3AM1A56AK2C1XAFJ4115ZSV26EB49BVQ10MGCS0 (wallet_6) | 100000000000000 |
+------------------------------------------------------+-----------------+
| ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP (wallet_8) | 100000000000000 |
+------------------------------------------------------+-----------------+
| ST3PF13W7Z0RRM42A8VZRVFQ75SV1K26RXEP8YGKJ (wallet_7) | 100000000000000 |
+------------------------------------------------------+-----------------+
| STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6 (wallet_9)  | 100000000000000 |
+------------------------------------------------------+-----------------+