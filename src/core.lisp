(in-package :ledger-asset-prices)

;;; Configuration

(defparameter *stock-config*
  (list
   '((:ticker . "SWDA_LN_ETF" )
     (:api . :marketstack)
     (:api-ticker . "SWDA.XLON")
     (:multiplier . 0.01))
   '((:ticker . "BRK.B" )
     (:api . :marketstack)
     (:api-ticker . "BrrrrRK.B"))))


(defun ledger-prices-for-date (date)
  (format-prices (fetch-prices date)))

#+nil
(progn
  (asdf:load-system :ledger-asset-prices)

  (fetch-prices "2021-03-03")

  )
