(defmodule ltest-testset-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "include/ltest-macros.lfe")

(deftest testset-with-one
  (list (is 'true)))

(deftest testset-with-two
  (list (is 'true)
        (is-not 'false)))

(deftest testset-with-three
  (list (is 'true)
        (is-not 'false)
        (is-equal 2 2)))

(deftest testset-nested
  (list (is 'true)
        (is-not 'false)
        (is-equal 2 2)
        (list (is 'true)
              (is-not 'false)
              (is-equal 1 1))))

(deftest testset-deeply-nested
  (list (is 'true)
        (is-not 'false)
        (is-equal 1 1)
        (list (is 'true)
              (is-not 'false)
              (is-equal 2 2)
              (list (is 'true)
                    (is-not 'false)
                    (is-equal 3 3)
                    (try
                      (progn
                        (is-equal 3 4)
                        (error 'unexpected-test-succes))
                      (catch
                        ((tuple type value _)
                         (check-failed-assert value
                                              (assert-equal-failed)))))))))
