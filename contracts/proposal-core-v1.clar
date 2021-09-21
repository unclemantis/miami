
;; proposal-core-v1
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

(define-map proposals { proposal-id: int } { creator: principal, title: (string-utf8 50), start: uint, end: uint, is-open: bool })
(define-map proposal-ballots { proposal-id: int, is-yes: bool } (list 100 { voter: principal }))
(define-map member-proposals { member-id: principal } { proposal-ids: (list 100 int) })

(define-data-var last-proposal-id int 0)
(define-data-var proposal-ids (list 100 int) (list ))

;; private functions
;;

(define-private (is-proposal (proposal (optional { creator: principal, title: (string-utf8 60), start: uint, end: uint, is-open: bool })))
  (is-some proposal))

(define-private (is-open-proposal (proposal (optional { creator: principal, title: (string-utf8 60), start: uint, end: uint, is-open: bool })))
  (is-eq (get is-open (unwrap-panic proposal)) true))

(define-private (is-closed-proposal (proposal (optional { creator: principal, title: (string-utf8 60), start: uint, end: uint, is-open: bool })))
  (is-eq (get is-open (unwrap-panic proposal)) false))

;; public functions
;;

(define-public (create-proposal (title (string-utf8 50)) (body (string-utf8 3000)) (duration uint))
    (let (
            (proposal-id (+ 1 (var-get last-proposal-id)))
            (member-proposal-ids (get-member-proposal-ids tx-sender))
            (creator tx-sender)
            (start block-height)
            (end (+ start duration)))
        (asserts! (unwrap-panic (contract-call? .proposal-body insert-body proposal-id body)) (err u1))
        (map-insert proposals { proposal-id: proposal-id } { creator: creator, title: title, start: start, end: end, is-open: true })
        (map-set member-proposals { member-id: tx-sender } { proposal-ids: (unwrap-panic (as-max-len? (append member-proposal-ids proposal-id) u100)) })
        (var-set proposal-ids (unwrap-panic (as-max-len? (concat (list proposal-id) (var-get proposal-ids)) u2)))
        (ok (var-set last-proposal-id proposal-id))))

(define-read-only (get-proposal-entry-by-member (member-id principal))
  (default-to
    { proposal-ids: (list ) }
    (map-get? member-proposals { member-id: member-id })
  )
)

(define-read-only (get-member-proposal-ids (member-id principal))
  (get proposal-ids (get-proposal-entry-by-member member-id))
)

(define-read-only (get-member-proposals (member-id principal))
    (filter is-proposal (map get-proposal (get-member-proposal-ids tx-sender)))
)

(define-read-only (get-open-member-proposals (member-id principal))
    (filter is-open-proposal (map get-proposal (get-member-proposal-ids tx-sender)))
)

(define-read-only (get-closed-member-proposals (member-id principal))
    (filter is-closed-proposal (map get-proposal (get-member-proposal-ids tx-sender)))
)

(define-read-only (get-proposal-ids)
    (var-get proposal-ids))

(define-read-only (get-proposals)
    (filter is-proposal (map get-proposal (get-proposal-ids))))

(define-read-only (get-open-proposals)
    (filter is-open-proposal (map get-proposal (get-proposal-ids))))

(define-read-only (get-closed-proposals)
    (filter is-closed-proposal (map get-proposal (get-proposal-ids))))

(define-read-only (get-open-proposal-totals)
    (to-int (len (get-open-proposals)))
)

(define-read-only (get-closed-proposal-totals)
    (to-int (len (get-closed-proposals)))
)

(define-read-only (get-member-proposal-totals (member-id principal))
    (to-int (len (get-member-proposals member-id)))
)

(define-read-only (get-open-member-proposal-totals (member-id principal))
    (to-int (len (get-open-member-proposals member-id)))
)

(define-read-only (get-closed-member-proposal-totals (member-id principal))
    (to-int (len (get-closed-member-proposals member-id)))
)

(define-read-only (get-proposal-totals)
    (to-int (len (get-proposal-ids))))

(define-read-only (get-proposal (id int))
    (map-get? proposals { proposal-id: id }))

(define-public (get-full-proposal (id int))
    (let (
            (proposal (unwrap-panic (get-proposal id)))
            (body (unwrap-panic (contract-call? .proposal-body get-proposal-body id)))
            (full-proposal (merge proposal body)))
        (ok full-proposal)))

(define-public (cast-ballot (proposal-id int) (is-yes bool))
    (ok (asserts! (map-insert proposal-ballots { proposal-id: proposal-id, is-yes: is-yes } (list { voter: tx-sender }))
        (let (
                (ballots (unwrap-panic (map-get? proposal-ballots { proposal-id: proposal-id, is-yes: is-yes })))
            )
            (ok (map-set proposal-ballots { proposal-id: proposal-id, is-yes: is-yes } (unwrap-panic (as-max-len? (append ballots { voter: tx-sender }) u100))))
            ))))

(define-read-only (get-yes-ballots (proposal-id int))
    (unwrap-panic (map-get? proposal-ballots { proposal-id: proposal-id, is-yes: true })))

(define-read-only (get-no-ballots (proposal-id int))
    (unwrap-panic (map-get? proposal-ballots { proposal-id: proposal-id, is-yes: false })))

(define-read-only (get-yes-ballot-totals (proposal-id int))
    (to-int (len (get-yes-ballots)))
)

(define-read-only (get-no-ballot-totals (proposal-id int))
    (to-int (len (get-no-ballots)))
)

(define-read-only (get-ballot-totals (proposal-id int))
    (+ (get-yes-ballot-totals) (get-no-ballot-totals))
)

(define-public (get-member-details (member-id principal))
    (let (
            (member (contract-call? .member get-member member-id))
            (member-proposal-totals (get-member-proposal-totals member-id))
            (open-member-proposal-totals (get-open-member-proposal-totals member-id))
            (closed-member-proposal-totals (get-closed-member-proposal-totals member-id))
        )
        (ok (merge (unwrap-panic member) { member-proposal-totals: member-proposal-totals, open-member-proposal-totals: open-member-proposal-totals, closed-member-proposal-totals: closed-member-proposal-totals }))
    )
)
