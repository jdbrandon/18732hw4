--------------------------------------------------------------------------------
-- File: bridge_controller.ads
-- 18-732 (Spring 2015) : Assignment 4B
-- 
-- You will need to add the correct Pre and Post conditions in this file. Some
-- conditions have been included for your, but you are welcome to change them.
-- 
--------------------------------------------------------------------------------

pragma SPARK_Mode (On);

package Bridge_Controller is


--------------------- Don't change this part below this line ------------------

-- Input type: r at A, car at B, cars at both (Two), cars at Neither
type Next_Car is (A, B, T, N);
type Event_Sequence is array (Positive) of Next_Car;

-- Traffic light state
type Traffic_Light is (RED, GREEN);


-- Global Variables that define the state of the controller
Light_A: Traffic_Light;
Light_B: Traffic_Light;
W_A : Natural;  -- Natural is an Integer that is >= 0
W_B : Natural;
Cross_Counter : Natural;
Just_Switched : Boolean; -- True if we have just switched the traffic lights


--------------------- Don't change the part above this line --------------------

function Start_State return Boolean is
(
  -- Start State
  ((Light_A = RED) and 
  (Light_B = RED) and
  (W_A = 0) and
  (W_B = 0) and
  (Cross_Counter < 5))
);

function Valid return Boolean is
(
  -- Write the condition for a valid state here.

  Start_State or
  -- Simple A
  ((Light_A = GREEN) and
   (Light_B = RED) and
   (W_A >= 0) and
   (W_B = 0) and
   Cross_Counter <= 5) or
  -- Simple B
  ((Light_A = RED) and
   (Light_B = GREEN) and
   (W_A = 0) and
   (W_B >= 0) and
   Cross_Counter <= 5) or
  -- Both A
  ((Light_A = GREEN) and
   (Light_B = RED) and
   (W_A >= 0) and
   (W_B >= 0) and
   Cross_Counter <= 5) or
  -- A Switch B
  ((Light_A = RED) and
   (Light_B = GREEN) and
   (W_A > 0) and
   (W_B >= 0) and
   (Cross_Counter = 5) and
   Just_Switched) or
  -- Both B
  ((Light_A = RED) and
   (Light_B = GREEN) and
   (W_A >= 0) and
   (W_B >= 0) and
   Cross_Counter <= 5) or
  -- B Switch A
  ((Light_A = GREEN) and
   (Light_B = RED) and
   (W_A >= 0) and
   (W_B > 0) and
   (Cross_Counter = 5) and
   Just_Switched)
);

function OneGreen return Boolean is
(
  (Light_A = GREEN) xor (Light_B = GREEN)
);

function BothGreen return Boolean is 
( 
  (Light_A = GREEN) and  (Light_B = GREEN)
);

function Both_Red return Boolean is 
( 
  (Light_A = RED) and  (Light_B = RED)
);

procedure Init
with Post => Start_State;

procedure Tick
(Next : Next_Car)
with Pre => Valid,
     Post => Valid and not BothGreen;

procedure Increment_W_A
with Post =>
      (W_A'Old <= W_A);
procedure Increment_W_B
with Post =>
      (W_B'Old <= W_B);
procedure Simple_Case
with Pre => 
      ((W_A > 0) xor (W_B > 0)) and 
      (OneGreen or Both_Red),
     Post =>
      (Cross_Counter <= 5) and 
      OneGreen and
      Valid;

procedure Cross
with Pre => 
      (((W_A > 0) and Light_A = GREEN) or
       ((W_B > 0) and Light_B = GREEN)) and
      not BothGreen and
      Cross_Counter < 5 and
      Valid,
     Post => 
      Valid;

procedure Switch_Lights
with Pre => OneGreen and not BothGreen,
 Post => 
  Light_A = Light_B'Old and
  Light_B = Light_A'Old and
  W_A = W_A'Old and
  W_B = W_B'Old and
  Just_Switched;

procedure Increment_Cross_Counter
with Pre => (Cross_Counter < 5),
     Post =>  (Cross_Counter = (Cross_Counter'Old + 1));

procedure Reset_Cross_Counter
with Post =>
      Cross_Counter = 0 and
      not Just_Switched;

end Bridge_Controller;
