(in-package :ledger-asset-prices)

(defun alist-str-get (al k)
  (cdr (assoc k al :test 'equal)))

(defun alist-get (al k)
  (cdr (assoc k al)))

(defparameter *currencies-by-exchange*
  '(("XWAR" . "PLN")))

(defparameter *marketstack-api-key*
  (uiop:getenv "MARKETSTACK_API_KEY"))



(defun marketstack-uri (ticker date)
  (quri:make-uri :scheme "http"
                 :host "api.marketstack.com"
                 :path (str:concat "/v1/eod/" date)
                 :query (quri:url-encode-params (list (cons "access_key" *marketstack-api-key*)
                                                      (cons "symbols" ticker)))))

(defun currency-for-exchange (ex)
  (alist-str-get *currencies-by-exchange* ex))

(defmethod fetch-price ((api (eql :marketstack)) stock date)
  (let* ((uri (marketstack-uri (alist-get stock :api-ticker) date))
         (stream (dex:get uri))
         (body (jonathan:parse stream :as :alist))
         (data (first (alist-str-get body "data"))))
    (list
     (cons :raw-body body)
     (cons :date date)
     (cons :ticker (alist-get stock :ticker))
     (cons :price (alist-str-get data "close"))
     (cons :currency (currency-for-exchange (alist-str-get data "exchange"))))))

#+nil
(progn

  (fetch-price :marketstack
               '((:ticker . "DECORA")
                 (:api . :marketstack)
                 (:api-ticker . "DCR.XWAR"))
               "2021-02-15")
  
  )
