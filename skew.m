function bx = skew(b)
    bx = [0 -b(3) b(2); ...
          b(3) 0 -b(1); ...
          -b(2) b(1) 0];
end