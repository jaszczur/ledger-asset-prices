(in-package :ledger-asset-prices.main)

(defun start (args)
  (dolist (line (ledger-prices-for-date (first args)))
    (format t "~a~%" line)))

(defun main ()
  (start (uiop:command-line-arguments)))

#+nil
(progn
  (asdf:make :ledger-asset-prices/executable)

  (start '("2021-02-25"))
  
  )
