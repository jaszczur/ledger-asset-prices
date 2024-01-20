LISP ?= qlot exec ros -Q
## We use --non-interactive with SBCL so that errors don't interrupt the CI.
# LISP_FLAGS ?= --no-userinit --non-interactive
LISP_FLAGS ?= --non-interactive

application:
	$(LISP) $(LISP_FLAGS) \
		--eval '(require "asdf")' \
		--load ledger-asset-prices.asd \
		--eval '(asdf:make :ledger-asset-prices/executable)' \
		--eval '(uiop:quit)' || (printf "\n%s\n%s\n" "Compilation failed, see the above stacktrace." && exit 1)

clean:
	rm -f src/*.fasl
	rm -f *.fasl
	rm -f fetch-ledger-prices
