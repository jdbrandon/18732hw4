--------------------------------------------------------------------------------
-- File: sort2.ads
-- 18-732 (Spring 2015) : Assignment 4B
-- 
-- You will need to add the correct Post condition for the Sort procedure.
-- 
--------------------------------------------------------------------------------

pragma SPARK_Mode (On);

package Sort2 is

MAX_CAPACITY :constant Integer := 1000;

type Element is new Integer;
subtype Index is Integer range 1 .. MAX_CAPACITY;
type Array_T is array (Index) of Element;


procedure Sort
( A : in out Array_T ; last : Index)
with Post =>
(
  -- Write a condition that makes sure that any element the resulting array,
  -- did exist in the original array.
  (for all K1 in A'First .. last =>
    (for some K2 in A'First .. last => A(K1) = A'Old(K2) )
  )
);

end Sort2;
