(in-package :ledger-asset-prices.test)

(defmacro define-test (name &body body)
  `(test ,(intern (concatenate 'string (symbol-name 'test-) (symbol-name name)))
     ,@body))

(defun run-tests ()
  (1am:run))

(defparameter *sample-prices* 
  (list 
   '((:time . "2021-01-24 20:26:00")
     (:ticker . "BETAM40TR")
     (:currency . "PLN")
     (:price . 58.00))
   '((:time . "2021-01-24 20:26:00")
     (:ticker . "CDPROJEKT")
     (:currency . "PLN")
     (:price . 250.10))
   '((:time . "2021-01-24 20:26:00")
     (:ticker . "DECORA")
     (:currency . "PLN")
     (:price . 30.00))))

(define-test format-prices
  (is (equal
       (list  "P 2021-01-24 20:26:00 \"BETAM40TR\" 58.0 \"PLN\""
              "P 2021-01-24 20:26:00 \"CDPROJEKT\" 250.1 \"PLN\""
              "P 2021-01-24 20:26:00 \"DECORA\" 30.0 \"PLN\"")
       (ledger-asset-prices:format-prices *sample-prices*)))
  (is (equal nil (ledger-asset-prices:format-prices '()))))

(define-test format-prices-lines
  (is (string=
       "P 2021-01-24 20:26:00 \"BETAM40TR\" 58.0 \"PLN\"
P 2021-01-24 20:26:00 \"CDPROJEKT\" 250.1 \"PLN\"
P 2021-01-24 20:26:00 \"DECORA\" 30.0 \"PLN\""
       (ledger-asset-prices:format-prices-lines *sample-prices*)))

  (is (string= "" (ledger-asset-prices:format-prices-lines '()))))

#+nil
(progn
  (run-tests)

  (setf *tests* nil)

  )
