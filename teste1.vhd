----------------------------------------------------------------------------------
-- Company: UFRJ - Escola Politecnica
-- Engineer: Matheus Viana, Bernardo Elias, Julio Silva
-- 
-- Create Date:    11/18/2026 
-- Design Name:    4-bit ALU
-- Module Name:    teste1 - Behavioral 
-- Project Name:   EEL480 - Digital Systems TP1
-- Target Devices: Xilinx Spartan-3
-- Description:    Simple test wrapper for validating the Logic Unit (projeto1Log)
--                 with fixed 4-bit operands.
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for the logic unit test module
entity teste1 is
    Port ( out11 : out STD_LOGIC_VECTOR (3 downto 0); -- 4-bit result output
           sel1  : in  STD_LOGIC_VECTOR (1 downto 0));-- 2-bit operation selector
end teste1;

architecture Behavioural of teste1 is
    -- Logic unit component declaration
    component projeto1Log
        Port ( in1  : in  STD_LOGIC_VECTOR (3 downto 0);
               in2  : in  STD_LOGIC_VECTOR (3 downto 0);
               out1 : out STD_LOGIC_VECTOR (3 downto 0);
               sel  : in  STD_LOGIC_VECTOR (1 downto 0));
    end component;

    -- Fixed test operands
    signal in11, in21 : STD_LOGIC_VECTOR (3 downto 0);

begin
    -- Assign constant test values (5 and 3 in binary)
    in11 <= "0101";
    in21 <= "0011";

    -- Instantiate logic unit under test
    PR0: projeto1Log port map (in1 => in11, in2 => in21, out1 => out11, sel => sel1);
end Behavioural;