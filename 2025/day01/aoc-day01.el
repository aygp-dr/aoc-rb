(defun aoc-parse-rotation (str)
  "Parse rotation like 'L43' into (direction . amount)."
  (let ((dir (substring str 0 1))
        (num (string-to-number (substring str 1))))
    (cons dir num)))

(defun aoc-apply-rotation (position rotation)
  "Apply a rotation to position, return new position (mod 100)."
  (let* ((dir (car rotation))
         (amount (cdr rotation))
         (delta (if (string= dir "L") (- amount) amount)))
    (mod (+ position delta) 100)))

(defun aoc-day01-solve (input)
  "Solve Day 01 Part 1: count zeros."
  (let ((position 50)
        (zero-count 0)
        (rotations (mapcar #'aoc-parse-rotation
                           (split-string input "\n" t))))
    (dolist (rot rotations)
      (setq position (aoc-apply-rotation position rot))
      (when (= position 0)
        (cl-incf zero-count)))
    zero-count))
