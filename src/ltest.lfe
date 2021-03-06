(defmodule ltest
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(defun skip-test-patt () '".*_skip")
(defun skip-test-group-patt () '"(.*)(_skip)")

(defun get-test-beams (path)
  "Get the compiled .beam files, but without the .beam extension. The list of
  files generated by this function are meant to be consumed by (code:load_abs)."
  (lists:map
    #'filename:rootname/1
    (filelib:wildcard
      (filename:join (list path ".eunit" "*.beam")))))

(defun get-integration-beams ()
  (get-integration-beams "."))

(defun get-integration-beams (path)
  (lists:filter
    #'integration?/1
    (get-test-beams path)))

(defun get-system-beams ()
  (get-system-beams "."))

(defun get-system-beams (path)
  (lists:filter
    #'system?/1
    (get-test-beams path)))

(defun get-unit-beams ()
  (get-unit-beams "."))

(defun get-unit-beams (path)
  (lists:filter
    #'unit?/1
    (get-test-beams path)))

(defun has-behaviour? (beam type)
  (lists:member
    type
    (lutil-file:get-beam-behaviors beam)))

(defun integration? (beam)
  (has-behaviour? beam 'ltest-integration))

(defun system? (beam)
  (has-behaviour? beam 'ltest-system))

(defun unit? (beam)
  (has-behaviour? beam 'ltest-unit))

(defun check-skip-funcs (funcs)
  (lists:map
    (match-lambda
      (((tuple func arity))
        (case (re:run (atom_to_list func) (skip-test-patt))
          ((tuple 'match _) `#(,func ,arity))
          (_ 'false))))
    funcs))

(defun check-skipped-tests (funcs)
  (lists:map
    (match-lambda
      (((tuple func arity))
        (case (re:split (atom_to_list func)
                        (++ (skip-test-group-patt))
                        '(#(return list)))
          ((list '() test-name _ '()) test-name)
          (_ 'false))))
    funcs))

(defun get-skip-funcs (module)
  (lutil-file:filtered
    #'check-skip-funcs/1
    (lutil-file:get-module-exports module)))

(defun get-skipped-tests (module)
  (lutil-file:filtered
    #'check-skipped-tests/1
    (lutil-file:get-module-exports module)))

(defun check-failed-assert (data expected)
  "This function
    1) unwraps the data held in the error result returned by a failed
       assertion, and
    2) checks the buried failure type against an expected value, asserting
       that they are the same."
  (let (((tuple failure-type _) data))
    (is-equal failure-type expected)))

(defun check-wrong-assert-exception (data expected)
  "This function
    1) unwraps the data held in the error result returned by
       assert-exception when an unexpected error occurs, and
    2) checks the buried failure type against an expected value, asserting
       that they are the same."
  (let (((tuple 'assertException_failed
    (list _ _ _ _ (tuple fail-type _))) data))
    (is-equal fail-type expected)))
