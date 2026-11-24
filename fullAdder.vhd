----------------------------------------------------------------------------------
-- Company: UFRJ - Escola Politecnica
-- Engineer: Matheus Viana, Bernardo Elias, Julio Silva
-- 
-- Create Date:    11/18/2026 
-- Design Name:    4-bit ALU
-- Module Name:    fullAdder - Behavioral 
-- Project Name:   EEL480 - Digital Systems TP1
-- Target Devices: Xilinx Spartan-3
-- Description:    1-bit Full Adder used as a building block for arithmetic operations.
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for a 1-bit Full Adder
entity fullAdder is
    Port ( X    : in  STD_LOGIC;  -- First input bit
           Y    : in  STD_LOGIC;  -- Second input bit
           Z    : out STD_LOGIC;  -- Sum output bit
           Cin  : in  STD_LOGIC;  -- Carry-in bit
           Cout : out STD_LOGIC); -- Carry-out bit
end fullAdder;

architecture Behavioral of fullAdder is

begin
    -- Sum calculation: X XOR Y XOR Cin
    Z <= (X xor Y) xor Cin;
    
    -- Carry-out calculation: majority function of X, Y, and Cin
    Cout <= (X and Y) or (Cin and X) or (Cin and Y);

end Behavioral;