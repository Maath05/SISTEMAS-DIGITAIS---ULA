----------------------------------------------------------------------------------
-- Company: UFRJ - Escola Politecnica
-- Engineer: Matheus Viana, Bernardo Elias, Julio Silva
-- 
-- Create Date:    11/18/2026 
-- Design Name:    4-bit ALU
-- Module Name:    projeto1Log - Behavioral 
-- Project Name:   EEL480 - Digital Systems TP1
-- Target Devices: Xilinx Spartan-3
-- Description:    4-bit Logic Unit supporting AND, OR, NOT, and XOR operations.
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for the 4-bit Logic Unit
entity projeto1Log is
    Port ( in1  : in  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit Operand A
           in2  : in  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit Operand B
           out1 : out STD_LOGIC_VECTOR (3 downto 0); -- 4-bit Logic result
           sel  : in  STD_LOGIC_VECTOR (1 downto 0));-- 2-bit Logic operation selector
end projeto1Log;

architecture Behavioral of projeto1Log is

    -- Internal signals for each bitwise logic operation
    signal sand, sor, snot, sxor : STD_LOGIC_VECTOR (3 downto 0);

begin
    -- Perform bitwise logic operations
    snot <= not in1;
    sand <= in1 and in2;
    sor  <= in1 or in2;
    sxor <= in1 xor in2;
    
    -- Output multiplexer:
    -- "01" -> AND, "10" -> OR, "11" -> NOT (in1), "00" -> XOR
    out1 <= sand when sel = "01" else
            sor  when sel = "10" else
            snot when sel = "11" else
            sxor;
end Behavioral;