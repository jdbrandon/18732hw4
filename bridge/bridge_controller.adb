--------------------------------------------------------------------------------
-- File: bridge_controller.adb
-- 18-732 (Spring 2015) : Assignment 4B
-- 
-- Don't Change this file.
-- It will be replaced with a fresh copy when grading in Autolab
--------------------------------------------------------------------------------

pragma SPARK_Mode (On);

package body Bridge_Controller is

---- Fixed pre- and post-condtions ----
procedure A_B_Cross
with Pre =>     Light_A = GREEN
            and Cross_Counter < 5
            and W_A > 0
            and Valid,
     Post => Valid;

procedure B_A_Cross
with Pre =>     Light_B = GREEN
            and Cross_Counter < 5
            and W_B > 0
            and Valid,
     Post => Valid;


procedure Simulate (E: Event_Sequence)
with Post => Valid;

---- Implementation ----


procedure Simulate
(E: Event_Sequence) is
begin

  Init;

  for I in E'Range loop

    -- We need this invariant in order for SPARK to prove that
    -- that the state is valid in each iteration
    pragma Loop_Invariant (Valid);

    Tick (E(I));
  end loop;

end Simulate;


procedure Init is
begin
  Light_A := RED;
  Light_B := RED;
  W_A := 0;
  W_B := 0;
  Cross_Counter := 0;

end Init;


procedure Tick
(Next : Next_Car) is
begin

  case Next is
  when A => Increment_W_A; 
  when B => Increment_W_B;
  when T => Increment_W_A; Increment_W_B;
  when N => NULL;
  end case;

  if W_A = 0 xor W_B = 0 then
    -- Exaclty one side have waiting cars
    Simple_Case;

  elsif W_A > 0 and W_B > 0 then
    -- We have cars waiting on both sides

    if Light_A = RED and Light_B = RED then
      -- We are in the initial state. Break the tie in favor of the A side.
      Light_A := GREEN;
      A_B_Cross;

    else

      if Cross_Counter < 5 then
        Cross;
      else
        Switch_Lights;
        Reset_Cross_Counter;
        Cross;
      end if;  

    end if;    
  end if;
end Tick;


procedure Increment_W_A is
begin
  W_A := (if W_A < Integer'Last then W_A + 1 else W_A);
end Increment_W_A;


procedure Increment_W_B is
begin
  W_B := (if W_B < Integer'Last then W_B + 1 else W_B);
end Increment_W_B;


procedure Cross is
begin
        if Light_A = GREEN then
          A_B_Cross;
        else
          B_A_Cross;
        end if;
end Cross;


procedure Simple_Case is
begin
  Reset_Cross_Counter;
  if W_A > 0 then
    if Light_A = RED then Light_A := GREEN; Light_B := RED; end if;
    A_B_Cross;
  else
    if Light_B = RED then Light_B := GREEN; Light_A := RED; end if;
    B_A_Cross;
  end if;
end Simple_Case;


procedure A_B_Cross is
begin
  W_A := W_A - 1;
  Increment_Cross_Counter;
end A_B_Cross;


procedure B_A_Cross is
begin
  W_B := W_B - 1;
  Increment_Cross_Counter;
end B_A_Cross;


procedure Switch_Lights is
begin
  if Light_A = RED then Light_A := GREEN; else Light_A := RED; end if;
  if Light_B = RED then Light_B := GREEN; else Light_B := RED; end if;
end Switch_Lights;


procedure Increment_Cross_Counter is
begin
  Cross_Counter := Cross_Counter + 1;
end Increment_Cross_Counter;


procedure Reset_Cross_Counter is
begin
  Cross_Counter := 0;
end Reset_Cross_Counter;


end Bridge_Controller;
