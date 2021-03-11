(in-package :ledger-asset-prices)

(defgeneric fetch-stock-price (api stock date)
  (:documentation "Fetches asset price from given API at given date"))

(defun fetch-price (date stock)
  (fetch-stock-price (cdr (assoc :api stock)) stock date))

(defun fetch-prices (date &optional (config *stock-config*))
  (loop for stock in config
        for stock-price = (restart-case (fetch-price date stock)
                            (skip-nonexisting-stock () nil))
        when stock-price collect it))
