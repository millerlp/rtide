## Test environments

release 4.1.0

* OSX (local) - release
* OSX (actions) - release
* Ubuntu (actions) - 3.4 to 3.6, oldrel, release and devel
* Windows (actions) - release
* Windows (winbuilder) - devel

## R CMD check results

0 errors | 0 warnings | 1 note

Found the following (possibly) invalid URLs:
  URL: https://poissonconsulting.shinyapps.io/rtide/
    From: README.md
    Status: Error
    Message: libcurl error code 35:
      	schannel: next InitializeSecurityContext failed: SEC_E_ILLEGAL_MESSAGE (0x80090326) - This error usually occurs when a fatal SSL/TLS alert is received (e.g. handshake failed).

The URL is valid.
