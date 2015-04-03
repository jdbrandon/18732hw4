--------------------------------------------------------------------------------
-- File: sort2.adb
-- 18-732 (Spring 2015) : Assignment 4B
-- 
-- Don't Change this file.
-- It will be replaced with a fresh copy when grading in Autolab
--------------------------------------------------------------------------------

pragma SPARK_Mode (On);

package body Sort2 is


-- Specs and implementation of the Swap procedure --

procedure Swap (A : in out Array_T; I : Index; J : Index) with
      Post =>
      (A (I) = A'Old (J) and
       A (J) = A'Old (I) and
       (for all K in A'Range =>
          (if K /= I and K /= J then A (K) = A'Old (K))));

procedure Swap (A : in out Array_T; I : Index; J : Index) is
  Temp : Element;
begin
  Temp  := A (I);
  A (I) := A (J);
  A (J) := Temp;
end Swap;


-- Specs and implementaion of the Insert_Sorted --
-- A procedure that implement the inner loop of insertion sort. It
-- "insert" the element at A(I) into the Array A(A'First .. I-1),
-- which must be already sorted, such that the resulting Array in
-- A(A'First .. I) is sorted in an ascending order.

procedure Insert_Sorted( A: in out Array_T; I: Index)
with Post =>
(
  (for all K1 in A'First .. I =>
     (for some K2 in A'First .. I => A(K1) = A'Old(K2) )
  )

  and

  -- Here we want to make sure that we did not change the
  -- other elements of the array (i.e., not in A'First .. I).
  (if I < A'Last then
     (for all K in I+1 .. A'Last  => A(K) = A'Old(K) )
  )
);

procedure Insert_Sorted( A: in out Array_T; I: Index)
is
  J : Index;
  B : Array_T;
begin
  -- Saving the original array in order to use it
  -- in the assertion below
  pragma Warnings (Off, "unused assignment");
  B := A;
  pragma Warnings (on, "unused assignment");

  J := I;
  while J > A'First and then A(J-1) > A(J) loop
    Swap(A,J,J-1);

    -- This needed to convice spark that range/index checks are provable
    pragma Loop_Invariant ( J-1 in A'Range);

    -- Loop invariants to cover all the cases for K in A'First .. I
    pragma Loop_Invariant ( if J > A'First+1 then 
                             (for all K in A'First .. J-2
                                => A(K) = A'Loop_Entry(K) )
                          );
    pragma Loop_Invariant ( A(J-1) = A'Loop_Entry(I) );
    pragma Loop_Invariant ( for all K in J .. I => A(K) = A'Loop_Entry(K-1) );

    -- Loop invariants to make sure that we did not modify the other elements
    pragma Loop_Invariant ( J < I+1 and J-1 < I+1); 
    pragma Loop_Invariant ( if I < A'Last then 
                             (for all K in I+1 .. A'Last => A(K) = A'Loop_Entry(K))
                          );

    J := J-1;
  end loop;

  -- Assert the postcondition. Somehow this is much faster than proving the
  -- postcondition directly.
  pragma assert (for all K1 in A'First .. I =>
                  (for some K2 in A'First .. I => A(K1) = B(K2) )
                );

end Insert_Sorted;

procedure Sort
( A : in out Array_T; last : Index ) is
begin
  for I in A'First+1 .. last loop

    -- Loop Invariant to help convince SPARK that the postcondition of
    -- the Insert_Sorted is true throughout the loop.
    pragma Loop_Invariant
            (for all K1 in A'First .. last =>
              (for some K2 in A'First .. last => A(K1) = A'Loop_Entry(K2) )
            );

    Insert_Sorted(A,I);
  end loop;
end Sort;

end Sort2;

