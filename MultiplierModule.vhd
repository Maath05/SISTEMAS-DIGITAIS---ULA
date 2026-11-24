----------------------------------------------------------------------------------
-- Company: UFRJ - Escola Politecnica
-- Engineer: Matheus Viana, Bernardo Elias, Julio Silva
-- 
-- Create Date:    11/18/2026 
-- Design Name:    4-bit ALU
-- Module Name:    MultiplierModule - Behavioral 
-- Project Name:   EEL480 - Digital Systems TP1
-- Target Devices: Xilinx Spartan-3
-- Description:    Basic cell for the array multiplier combining two AND gates 
--                 and a 1-bit Full Adder.
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for a single multiplier cell
entity MultiplierModule is
    Port ( Xk   : in  STD_LOGIC;  -- First operand bit for partial product 1
           Yk   : in  STD_LOGIC;  -- Second operand bit for partial product 1
           Xx   : in  STD_LOGIC;  -- First operand bit for partial product 2
           Yx   : in  STD_LOGIC;  -- Second operand bit for partial product 2
           Cin  : in  STD_LOGIC;  -- Carry-in from previous cell
           Z    : out STD_LOGIC;  -- Partial sum output
           Cout : out STD_LOGIC); -- Carry-out to next cell
end MultiplierModule;

architecture Behavioral of MultiplierModule is
    -- Full Adder component declaration
    component fullAdder
        Port ( X    : in  STD_LOGIC;
               Y    : in  STD_LOGIC;
               Z    : out STD_LOGIC;
               Cin  : in  STD_LOGIC;
               Cout : out STD_LOGIC);
    end component;

    -- Internal signals for the partial products
    signal X1, X2 : STD_LOGIC;

begin
    -- Compute partial products using AND gates
    X1 <= Xk and Yk;
    X2 <= Xx and Yx;
    
    -- Add the two partial products along with the carry-in
    FA: fullAdder port map (X => X1, Y => X2, Cin => Cin, Z => Z, Cout => Cout);

end Behavioral;