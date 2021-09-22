
;; member
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

(define-map members { member-id: principal } { id: principal, name: (string-utf8 50), image-url: (string-utf8 50), email: (string-utf8 50) })

(define-data-var member-ids (list 100 principal) (list ))

;; private functions
;;

(define-private (is-member (member (optional { id: principal, name: (string-utf8 50), image-url: (string-utf8 50), email: (string-utf8 50) })))
  (is-some member))

;; public functions
;;

(define-read-only (does-member-exist (member-id principal))
    (begin
        (if (is-some (map-get? members { member-id: member-id }))
            true
            false)))

(define-read-only (get-member-ids)
    (var-get member-ids))

(define-read-only (get-member (member-id principal))
    (map-get? members { member-id: member-id }))

(define-read-only (get-members)
    (filter is-member (map get-member (get-member-ids))))

(define-public (create-member (name (string-utf8 50)) (image-url (string-utf8 50)) (email (string-utf8 50)))
    (begin
        (asserts! (map-insert members { member-id: tx-sender } { id: tx-sender, name: name, image-url: image-url, email: email })
            (err u1))
        (ok (var-set member-ids (unwrap-panic (as-max-len? (append (var-get member-ids) tx-sender) u2))))))
