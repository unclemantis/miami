
;; member
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

(define-map members { member-id: principal } { name: (string-utf8 50), imageUrl: (string-utf8 50), email: (string-utf8 50) })

(define-data-var member-ids (list 100 principal) (list ))

;; private functions
;;

(define-private (is-member (member (optional { id: principal, name: (string-utf8 50), imageUrl: (string-utf8 50), email: (string-utf8 50) })))
  (is-some member))

;; public functions
;;

(define-read-only (does-member-exist)
    (begin
        (if (is-some (map-get? members { member-id: tx-sender }))
            true
            false)))

(define-read-only (get-member-ids)
    (var-get member-ids))

(define-read-only (get-member (member-id principal))
    (some (merge (unwrap-panic (map-get? members { member-id: member-id })) { id: member-id })))

(define-read-only (get-members)
    (filter is-member (map get-member (get-member-ids))))

(define-public (create-member (name (string-utf8 50)) (imageUrl (string-utf8 50)) (email (string-utf8 50)))
    (begin
        (asserts! (map-insert members { member-id: tx-sender } { name: name, imageUrl: imageUrl, email: email })
            (err u1))
        (ok (var-set member-ids (unwrap-panic (as-max-len? (append (var-get member-ids) tx-sender) u100))))))
