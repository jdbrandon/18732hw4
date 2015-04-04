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


function Valid return Boolean is
(
  -- Write the condition for a valid state here. 
  (Light_A = RED and
   Light_B = RED and
   W_A = 0 and 
   W_B = 0 and 
   Cross_Counter = 0) or
  (Light_A = GREEN and
   Light_B = RED and
   W_A >= 0 and
   W_B = 0 and
   Cross_Counter < 5) or
  (Light_A = RED and
   Light_B = GREEN and
   W_A = 0 and
   W_B >= 0 and
   Cross_Counter < 5) or
  (Light_A = GREEN and
   Light_B = RED and
   W_A > 0 and 
   W_B > 0 and
   Cross_Counter < 5) or
  (Light_A = RED and 
   Light_B = GREEN and
   W_A > 0 and 
   W_B > 0 and
   Cross_Counter < 5)
);

procedure Init
with Post =>
  Light_A = RED and
  Light_B = RED and
  W_A = 0 and
  W_B = 0 and
  Cross_Counter = 0 and
  Valid;

procedure Tick
(Next : Next_Car)
with Post => Valid;

procedure Increment_W_A
with Post => 
      ((W_A'Old < Natural'Last) and 
       (W_A = (W_A'Old + 1))) or
      ((W_A'Old = Natural'Last) and (W_A = Natural'Last));
procedure Increment_W_B
with Pre => W_B < Natural'Last,
     Post => 
      ((W_B'Old < Natural'Last) and
       (W_B = (W_B'Old + 1))) or
      ((W_B'Old = Natural'Last) and (W_B = Natural'Last));

procedure Simple_Case;

procedure Cross
with Pre => 
      (Cross_Counter < 5) and 
      ((W_A /= 0) or (W_B /= 0)),
     Post =>
      ((W_A = (W_A'Old - 1)) xor (W_B = (W_B'Old - 1))) and
      (Cross_Counter = Cross_Counter'Old + 1) and
      (Cross_Counter <= 5);

procedure Switch_Lights
with Pre =>
      (Light_A /= Light_B) and
      (not Just_Switched),
     Post => 
       (Light_A = Light_B'Old) and
       (Light_B = Light_A'Old) and
       (W_A = W_A'Old) and
       (W_B = W_B'Old) and
       Just_Switched;

procedure Increment_Cross_Counter
with Pre =>
      Cross_Counter /= Natural'Last,
     Post =>  (Cross_Counter = Cross_Counter'Old + 1);

procedure Reset_Cross_Counter
with Post =>
      (Cross_Counter = 0) and 
      (not Just_Switched);

end Bridge_Controller;
