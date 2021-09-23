
;; proposal-core-v1
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

(define-map proposals { proposal-id: int } { owner: principal, title: (string-utf8 50), summary: (string-utf8 100), start: uint, end: uint })
(define-map proposal-votes { proposal-id: int } (list 100 { voter: principal, yes: bool }))
(define-map member-proposals { member-id: principal } { proposal-ids: (list 100 int) })

(define-data-var last-proposal-id int 0)
(define-data-var proposal-ids (list 100 int) (list ))

;; private functions
;;

(define-private (does-member-have-miamicoin)
    (if (> (stx-get-balance tx-sender) u0) true false))

(define-private (is-proposal (proposal (optional { id: int, owner: principal, title: (string-utf8 50), summary: (string-utf8 100), start: uint, end: uint, isClosed: bool })))
  (is-some proposal))

(define-private (is-member (member (optional { id: principal, name: (string-utf8 50), imageUrl: (string-utf8 50), email: (string-utf8 50), member-proposal-totals: int, open-member-proposal-totals: int, closed-member-proposal-totals: int })))
  (is-some member))

(define-private (is-open-proposal (proposal (optional { id: int, owner: principal, title: (string-utf8 50), summary: (string-utf8 100), start: uint, end: uint, isClosed: bool })))
  (is-eq (get isClosed (unwrap-panic proposal)) false))

(define-private (is-closed-proposal (proposal (optional { id: int, owner: principal, title: (string-utf8 50), summary: (string-utf8 100), start: uint, end: uint, isClosed: bool })))
  (is-eq (get isClosed (unwrap-panic proposal)) true))

;; public functions
;;

(define-public (create-proposal (title (string-utf8 50)) (summary (string-utf8 100)) (body (string-utf8 3000)) (duration uint))
    (begin
        (asserts! (contract-call? .member does-member-exist) (err u1))
        (asserts! (does-member-have-miamicoin) (err u1))
        (let (
                (proposal-id (+ 1 (var-get last-proposal-id)))
                (member-proposal-ids (get-member-proposal-ids tx-sender))
                (owner tx-sender)
                (start block-height)
                (end (+ start duration)))
            (asserts! (unwrap-panic (contract-call? .proposal-body insert-body proposal-id body)) (err u1))
            (map-insert proposals { proposal-id: proposal-id } { owner: owner, title: title, summary: summary, start: start, end: end })
            (map-set member-proposals { member-id: tx-sender } { proposal-ids: (unwrap-panic (as-max-len? (concat (list proposal-id) member-proposal-ids) u100)) })
            (var-set proposal-ids (unwrap-panic (as-max-len? (concat (list proposal-id) (var-get proposal-ids)) u100)))
            (ok (var-set last-proposal-id proposal-id)))))

(define-public (create-proposal-vote (proposal-id int) (yes bool))
    (begin
        (asserts! (<= block-height (unwrap-panic (get end (map-get? proposals { proposal-id: proposal-id })))) (err u1))
        (asserts! (contract-call? .member does-member-exist) (err u1))
        (asserts! (does-member-have-miamicoin) (err u1))
        (ok (asserts! (map-insert proposal-votes { proposal-id: proposal-id } (list { voter: tx-sender, yes: yes }))
            (let (
                    (votes (unwrap-panic (map-get? proposal-votes { proposal-id: proposal-id })))
                )
                (ok (map-set proposal-votes { proposal-id: proposal-id } (unwrap-panic (as-max-len? (append votes { voter: tx-sender, yes: yes }) u100)))))))))

;; member read only functions
;;

(define-read-only (get-member-proposal-ids (member-id principal))
  (get proposal-ids (default-to { proposal-ids: (list ) } (map-get? member-proposals { member-id: member-id }))))

(define-read-only (get-member-proposals (member-id principal))
    (filter is-proposal (map get-proposal (get-member-proposal-ids tx-sender))))

(define-read-only (get-open-member-proposals (member-id principal))
    (filter is-open-proposal (map get-proposal (get-member-proposal-ids tx-sender))))

(define-read-only (get-closed-member-proposals (member-id principal))
    (filter is-closed-proposal (map get-proposal (get-member-proposal-ids tx-sender))))

(define-read-only (get-member-proposal-totals (member-id principal))
    (to-int (len (get-member-proposals member-id))))

(define-read-only (get-open-member-proposal-totals (member-id principal))
    (to-int (len (get-open-member-proposals member-id))))

(define-read-only (get-closed-member-proposal-totals (member-id principal))
    (to-int (len (get-closed-member-proposals member-id))))

(define-read-only (get-members)
    (filter is-member (map get-member (contract-call? .member get-member-ids))))

(define-read-only (get-member (member-id principal))
(some (merge (unwrap-panic (contract-call? .member get-member member-id)) 
        { member-proposal-totals: (get-member-proposal-totals member-id), 
        open-member-proposal-totals: (get-open-member-proposal-totals member-id), 
        closed-member-proposal-totals: (get-closed-member-proposal-totals member-id) })))

;; proposal read only functions
;;

(define-read-only (get-proposal-ids)
    (var-get proposal-ids))

(define-read-only (get-proposals)
    (filter is-proposal (map get-proposal (get-proposal-ids))))

(define-read-only (get-open-proposals)
    (filter is-open-proposal (map get-proposal (get-proposal-ids))))

(define-read-only (get-closed-proposals)
    (filter is-closed-proposal (map get-proposal (get-proposal-ids))))

(define-read-only (get-open-proposal-totals)
    (to-int (len (get-open-proposals))))

(define-read-only (get-closed-proposal-totals)
    (to-int (len (get-closed-proposals))))

(define-read-only (get-proposal-totals)
    (to-int (len (get-proposal-ids))))

(define-read-only (get-proposal (proposal-id int))
    (if (<= block-height (unwrap-panic (get end (map-get? proposals { proposal-id: proposal-id }))))
        (some (merge (unwrap-panic (map-get? proposals { proposal-id: proposal-id })) { id: proposal-id, isClosed: false }))
        (some (merge (unwrap-panic (map-get? proposals { proposal-id: proposal-id })) { id: proposal-id, isClosed: true }))))

(define-read-only (get-full-proposal (proposal-id int))
    (merge (unwrap-panic (get-proposal proposal-id)) (unwrap-panic (contract-call? .proposal-body get-proposal-body proposal-id))))

;; vote read only functions
;;

(define-read-only (get-proposal-votes (proposal-id int))
    (map-get? proposal-votes { proposal-id: proposal-id })
)

(define-read-only (get-proposal-total-votes (proposal-id int))
    (to-int (len (unwrap-panic (map-get? proposal-votes { proposal-id: proposal-id }))))
)