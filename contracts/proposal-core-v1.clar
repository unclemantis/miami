
;; proposal-core-v1
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

(define-map proposals { proposal-id: int } { id: int, owner: principal, title: (string-utf8 50), summary: (string-utf8 100), start: uint, end: uint })
(define-map proposal-ballots { proposal-id: int, is-yes: bool } (list 100 { voter: principal }))
(define-map member-proposals { member-id: principal } { proposal-ids: (list 100 int) })

(define-data-var last-proposal-id int 0)
(define-data-var proposal-ids (list 100 int) (list ))

;; private functions
;;

(define-private (is-proposal (proposal (optional { id: int, owner: principal, title: (string-utf8 50), summary: (string-utf8 100), start: uint, end: uint, isClosed: bool })))
  (is-some proposal))

(define-private (is-open-proposal (proposal (optional { id: int, owner: principal, title: (string-utf8 50), summary: (string-utf8 100), start: uint, end: uint, isClosed: bool })))
  (is-eq (get isClosed (unwrap-panic proposal)) false))

(define-private (is-closed-proposal (proposal (optional { id: int, owner: principal, title: (string-utf8 50), summary: (string-utf8 100), start: uint, end: uint, isClosed: bool })))
  (is-eq (get isClosed (unwrap-panic proposal)) true))

;; public functions
;;

(define-public (create-proposal (title (string-utf8 50)) (summary (string-utf8 100)) (body (string-utf8 3000)) (duration uint))
    (begin
        (asserts! (contract-call? .member is-member tx-sender) (err u1))
        (let (
                (proposal-id (+ 1 (var-get last-proposal-id)))
                (member-proposal-ids (get-member-proposal-ids tx-sender))
                (creator tx-sender)
                (start block-height)
                (end (+ start duration)))
            (asserts! (unwrap-panic (contract-call? .proposal-body insert-body proposal-id body)) (err u1))
            (map-insert proposals { proposal-id: proposal-id } { id: proposal-id, owner: creator, title: title, summary: summary, start: start, end: end })
            (map-set member-proposals { member-id: tx-sender } { proposal-ids: (unwrap-panic (as-max-len? (concat (list proposal-id) member-proposal-ids) u100)) })
            (var-set proposal-ids (unwrap-panic (as-max-len? (concat (list proposal-id) (var-get proposal-ids)) u2)))
            (ok (var-set last-proposal-id proposal-id)))))

(define-read-only (get-proposal-entry-by-member (member-id principal))
  (default-to
    { proposal-ids: (list ) }
    (map-get? member-proposals { member-id: member-id })))

(define-read-only (get-member-proposal-ids (member-id principal))
  (get proposal-ids (get-proposal-entry-by-member member-id)))

(define-read-only (get-member-proposals (member-id principal))
    (filter is-proposal (map get-proposal (get-member-proposal-ids tx-sender))))

(define-read-only (get-open-member-proposals (member-id principal))
    (filter is-open-proposal (map get-proposal (get-member-proposal-ids tx-sender))))

(define-read-only (get-closed-member-proposals (member-id principal))
    (filter is-closed-proposal (map get-proposal (get-member-proposal-ids tx-sender))))

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

(define-read-only (get-member-proposal-totals (member-id principal))
    (to-int (len (get-member-proposals member-id))))

(define-read-only (get-open-member-proposal-totals (member-id principal))
    (to-int (len (get-open-member-proposals member-id))))

(define-read-only (get-closed-member-proposal-totals (member-id principal))
    (to-int (len (get-closed-member-proposals member-id))))

(define-read-only (get-proposal-totals)
    (to-int (len (get-proposal-ids))))

(define-read-only (get-proposal (proposal-id int))
    (if (<= block-height (unwrap-panic (get end (map-get? proposals { proposal-id: proposal-id }))))
        (some (merge (unwrap-panic (map-get? proposals { proposal-id: proposal-id })) { isClosed: false }))
        (some (merge (unwrap-panic (map-get? proposals { proposal-id: proposal-id })) { isClosed: true }))))

(define-public (get-full-proposal (proposal-id int))
    (let (
            (proposal (unwrap-panic (get-proposal proposal-id)))
            (body (unwrap-panic (contract-call? .proposal-body get-proposal-body proposal-id)))
            (full-proposal (merge proposal body)))
        (ok full-proposal)))

(define-public (cast-ballot (proposal-id int) (is-yes bool))
    (begin
        (asserts! (<= block-height (unwrap-panic (get end (map-get? proposals { proposal-id: proposal-id })))) (err u1))
        (ok (asserts! (map-insert proposal-ballots { proposal-id: proposal-id, is-yes: is-yes } (list { voter: tx-sender }))
            (let (
                    (ballots (unwrap-panic (map-get? proposal-ballots { proposal-id: proposal-id, is-yes: is-yes })))
                )
                (ok (map-set proposal-ballots { proposal-id: proposal-id, is-yes: is-yes } (unwrap-panic (as-max-len? (append ballots { voter: tx-sender }) u100))))
                )))))

(define-read-only (get-yes-ballots (proposal-id int))
    (unwrap-panic (map-get? proposal-ballots { proposal-id: proposal-id, is-yes: true })))

(define-read-only (get-no-ballots (proposal-id int))
    (unwrap-panic (map-get? proposal-ballots { proposal-id: proposal-id, is-yes: false })))

(define-read-only (get-yes-ballot-totals (proposal-id int))
    (to-int (len (get-yes-ballots))))

(define-read-only (get-no-ballot-totals (proposal-id int))
    (to-int (len (get-no-ballots))))

(define-read-only (get-ballot-totals (proposal-id int))
    (+ (get-yes-ballot-totals) (get-no-ballot-totals)))

(define-public (get-member-details (member-id principal))
    (let (
            (member (contract-call? .member get-member member-id))
            (member-proposal-totals (get-member-proposal-totals member-id))
            (open-member-proposal-totals (get-open-member-proposal-totals member-id))
            (closed-member-proposal-totals (get-closed-member-proposal-totals member-id))
        )
        (ok (merge (unwrap-panic member) { member-proposal-totals: member-proposal-totals, open-member-proposal-totals: open-member-proposal-totals, closed-member-proposal-totals: closed-member-proposal-totals }))))
