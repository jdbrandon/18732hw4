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
  (Cross_Counter = 0) and
  (not Just_Switched))
);

function Valid return Boolean is
(
  -- Write the condition for a valid state here.

  Start_State or
  -- Simple A
  ((Light_A = GREEN) and
   (Light_B = RED) and
   (W_A >= 0) and
   (W_B >= 0) and
   (Cross_Counter <= 5) and
   (not Just_Switched)) or
  -- Simple B
  ((Light_A = RED) and
   (Light_B = GREEN) and
   (W_A >= 0) and
   (W_B >= 0) and 
   (Cross_Counter <= 5) and
   (not Just_Switched))
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
     Post => Valid;

procedure Increment_W_A
with Pre => not Just_Switched,
     Post =>
      W_A = (if W_A'Old < Natural'Last then W_A'Old + 1 else W_A'Old) and
      not Just_Switched;
procedure Increment_W_B
with Pre => not Just_Switched,
     Post =>
      W_B = (if W_B'Old < Natural'Last then W_B'Old + 1 else W_B'Old) and
      not Just_Switched;
procedure Simple_Case
with Pre => 
      ((W_A > 0) xor (W_B > 0)) and 
      (OneGreen or Both_Red),
     Post =>
      (Cross_Counter <= 5) and 
      not Just_Switched and 
      OneGreen and
      Valid;

procedure Cross
with Pre => 
      (((W_A > 0) and Light_A = GREEN) or
       ((W_B > 0) and Light_B = GREEN)) and
      not BothGreen and
      Cross_Counter < 5 and
      not Just_Switched,
     Post => 
      Valid and
      Cross_Counter <= 5 and
      not Just_Switched;
     -- Cross_Counter = (if Cross_Counter'Old < 5 then Cross_Counter'Old + 1 else Cross_Counter'Old);

procedure Switch_Lights
with Pre => (W_A > 0 and W_B > 0) and Cross_Counter = 5 and OneGreen and not Start_State and not Just_Switched,
     Post => 
  Light_A = Light_B'Old and
  Light_B = Light_A'Old and
  W_A = W_A'Old and
  W_B = W_B'Old and
  Cross_Counter = Cross_Counter'Old and
  OneGreen and
  Just_Switched;

procedure Increment_Cross_Counter
with Pre => (Cross_Counter < 5) and not Just_Switched,
     Post =>  (Cross_Counter = (Cross_Counter'Old + 1)) and
              (Cross_Counter <= 5) and
              not Just_Switched;

procedure Reset_Cross_Counter
with Post =>
      Cross_Counter = 0 and
      not Just_Switched;

end Bridge_Controller;
