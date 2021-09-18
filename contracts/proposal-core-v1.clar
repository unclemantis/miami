
;; proposal-core-v1
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

(define-map proposals { proposal-id: int } { creator: principal, title: (string-utf8 50), start: uint, end: uint, is-open: bool })
(define-map proposal-ballots { proposal-id: int, is-yes: bool } (list 100 { voter: principal }))

(define-data-var last-proposal-id int 0)
(define-data-var proposal-ids (list 100 int) (list ))

;; private functions
;;

(define-private (is-proposal (proposal (optional { creator: principal, title: (string-utf8 60), start: uint, end: uint, is-open: bool })))
  (is-some proposal)
)

;; public functions
;;

(define-read-only (get-proposal-ids)
    (var-get proposal-ids)
)

(define-read-only (get-proposals)
    (filter is-proposal (map get-proposal (get-proposal-ids)))
)

(define-read-only (get-proposal (id int))
    (map-get? proposals { proposal-id: id })
)

(define-public (get-full-proposal (id int))
    (let (
            (proposal (unwrap-panic (get-proposal id)))
            (body (unwrap-panic (contract-call? .proposal-body get-proposal-body id)))
            (full-proposal (merge proposal body))
        )
        (ok full-proposal)
    )
)

(define-public (create-proposal (title (string-utf8 50)) (body (string-utf8 3000)) (duration uint))
    (let (
            (id (+ 1 (var-get last-proposal-id)))
            (creator tx-sender)
            (start block-height)
            (end (+ start duration))
        )
        (asserts! (unwrap-panic (contract-call? .proposal-body insert-body id body)) (err u1))
        (map-insert proposals { proposal-id: id } { creator: creator, title: title, start: start, end: end, is-open: true })
        (var-set proposal-ids (unwrap-panic (as-max-len? (append (var-get proposal-ids) id) u2)))
        (ok (var-set last-proposal-id id))
    )
)

(define-read-only (get-yes-ballots (proposal-id int))
    (map-get? proposal-ballots { proposal-id: proposal-id, is-yes: true })
)

(define-read-only (get-no-ballots (proposal-id int))
    (map-get? proposal-ballots { proposal-id: proposal-id, is-yes: false })
)

(define-public (cast-ballot (proposal-id int) (is-yes bool))
    (ok (asserts! (map-insert proposal-ballots { proposal-id: proposal-id, is-yes: is-yes } (list { voter: tx-sender }))
        (let (
                (ballots (unwrap-panic (map-get? proposal-ballots { proposal-id: proposal-id, is-yes: is-yes })))
            )
            (ok (map-set proposal-ballots { proposal-id: proposal-id, is-yes: is-yes } (unwrap-panic (as-max-len? (append ballots { voter: tx-sender }) u100))))
            )
        )
    )
)