--------------------------------------------------------------------------------
-- File: sort1.adb
-- 18-732 (Spring 2015) : Assignment 4B
-- 
-- Don't Change this file.
-- It will be replaced with a fresh copy when grading in Autolab
--------------------------------------------------------------------------------

pragma SPARK_Mode (On);

package body Sort1 is


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
 with
  Pre => ( I > A'First and (for all K in A'First .. I-2 => A(K) <= A(K+1) ) ),
  Post => (
            (for all K in A'First .. I-1 => A(K) <= A(K+1))
          );


procedure Insert_Sorted( A: in out Array_T; I: Index)
is
  J : Index;
begin
  J := I;
  while J > A'First and then A(J-1) > A(J) loop
    Swap(A,J,J-1);

    -- This needed to convice spark that range/index checks are provable
    pragma Loop_Invariant ( J-1 in A'Range);

    -- These are needed to aid SPARK in proving the main loop invariant below
    pragma Loop_Invariant ( if J > A'First+1 then A(J-2) <= A(J));
    pragma Loop_Invariant ( if J > A'First+2 then (for all K in A'First .. J-3 => A(K) <= A(K+1)) );
    pragma Loop_Invariant ( if J > A'First+1 and J < I then (for all K in J .. I => A(J-2) <= A(K) ));

    -- This is the main loop invariant we want to prove
    pragma Loop_Invariant ( for all K in J-1 .. I-1 => A(K) <= A(K+1));

    J := J-1;
  end loop;
end Insert_Sorted;


-- The implementation of the Insertion sort
procedure Sort
( A : in out Array_T; last : Index ) is
begin
  for I in A'First+1 .. last loop

    -- You need to define this invariant, by modifying the function Invar in
    -- the .ads file.
    pragma Loop_Invariant ( Invar(A,I) );

    Insert_Sorted(A,I);
  end loop;
end Sort;

end Sort1;

