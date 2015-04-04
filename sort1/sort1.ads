--------------------------------------------------------------------------------
-- File: sort1.ads
-- 18-732 (Spring 2015) : Assignment 4B
-- 
-- You will need to add the correct Post condition for the Sort procedure. You
-- also need to modify the implementation of the 'Invar' function that defines
-- the loop invariant in for the main loop of the insertion sort.
-- 
--------------------------------------------------------------------------------

pragma SPARK_Mode (On);

package Sort1 is

MAX_CAPACITY :constant Integer := 1000;

type Element is new Integer;
subtype Index is Integer range 1 .. MAX_CAPACITY;
type Array_T is array (Index) of Element;

function Invar (A : Array_T; I : Index) return Boolean is
(
  -- Write the expression for the loop invariant here
  ( I > A'First and (for all K in A'First .. I-2 => A(K) <= A(K+1) ) )
);


procedure Sort
( A : in out Array_T ; last : Index)
with Post =>
(
  -- Write the postcondition, which ensures that the resulting array
  -- is sorted in an ascending order, here.
  ( last > A'First and (for all K in A'First .. last-1 => A(K) <= A(K+1) ) ) or
  ( last = A'First )
);

end Sort1;
