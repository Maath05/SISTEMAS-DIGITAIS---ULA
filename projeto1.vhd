----------------------------------------------------------------------------------
-- Company: UFRJ - Escola Politecnica
-- Engineer: Matheus Viana, Bernardo Elias, Julio Silva
-- 
-- Create Date:    11/18/2026 
-- Design Name:    4-bit ALU
-- Module Name:    projeto1 - Behavioral 
-- Project Name:   EEL480 - Digital Systems TP1
-- Target Devices: Xilinx Spartan-3
-- Description:    Top-level ALU module integrating logic and arithmetic units.
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for the 4-bit ALU
entity projeto1 is
    Port ( in1  : in  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit Operand A
           in2  : in  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit Operand B
           out1 : out STD_LOGIC_VECTOR (3 downto 0); -- 4-bit ALU result
           sel  : in  STD_LOGIC_VECTOR (2 downto 0));-- 3-bit operation selector
end projeto1;

architecture Behavioral of projeto1 is
    -- Logic unit component declaration
    component projeto1Log
        Port ( in1  : in  STD_LOGIC_VECTOR (3 downto 0);
               in2  : in  STD_LOGIC_VECTOR (3 downto 0);
               out1 : out STD_LOGIC_VECTOR (3 downto 0);
               sel  : in  STD_LOGIC_VECTOR (1 downto 0));
    end component;

    -- Arithmetic unit component declaration
    component projeto1Arit
        Port ( Cin  : in  STD_LOGIC;
               Cout : out STD_LOGIC;
               in1  : in  STD_LOGIC_VECTOR (3 downto 0);
               in2  : in  STD_LOGIC_VECTOR (3 downto 0);
               out1 : out STD_LOGIC_VECTOR (3 downto 0);
               sel  : in  STD_LOGIC_VECTOR (1 downto 0));
    end component;

    -- Internal signals to hold outputs from logic and arithmetic blocks
    signal outLog, outArit : STD_LOGIC_VECTOR (3 downto 0);

begin
    -- Instantiate logic unit (uses lower 2 bits of sel)
    PL1: projeto1Log port map (in1 => in1, in2 => in2, out1 => outLog, sel => sel(1 downto 0));
    
    -- Instantiate arithmetic unit (uses lower 2 bits of sel, Cin fixed to '0')
    PA1: projeto1Arit port map (in1 => in1, in2 => in2, out1 => outArit, sel => sel(1 downto 0), Cin => '0');
    
    -- Output multiplexer: MSB of sel chooses between Logic ('1') and Arithmetic ('0')
    out1 <= outLog when sel(2) = '1' else
            outArit;
end Behavioral;