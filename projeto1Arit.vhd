----------------------------------------------------------------------------------
-- Company: UFRJ - Escola Politecnica
-- Engineer: Matheus Viana, Bernardo Elias, Julio Silva
-- 
-- Create Date:    11/18/2026 
-- Design Name:    4-bit ALU
-- Module Name:    projeto1Arit - Behavioral 
-- Project Name:   EEL480 - Digital Systems TP1
-- Target Devices: Xilinx Spartan-3
-- Description:    4-bit Arithmetic Unit supporting Addition, Two's Complement 
--                 Subtraction, Multiplication, and Increment by 1.
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for the 4-bit Arithmetic Unit
entity projeto1Arit is
    Port ( Cin  : in  STD_LOGIC;                     -- Carry-in input
           Cout : out STD_LOGIC;                     -- Carry-out / Overflow output
           in1  : in  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit Operand A
           in2  : in  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit Operand B
           out1 : out STD_LOGIC_VECTOR (3 downto 0); -- 4-bit Arithmetic result
           sel  : in  STD_LOGIC_VECTOR (1 downto 0));-- 2-bit Arithmetic operation selector
end projeto1Arit;

architecture Behavioral of projeto1Arit is

    -- 1-bit Full Adder component
    component fullAdder
        Port ( X    : in  STD_LOGIC;
               Y    : in  STD_LOGIC;
               Z    : out STD_LOGIC;
               Cin  : in  STD_LOGIC;
               Cout : out STD_LOGIC);
    end component;

    -- Multiplier cell component
    component MultiplierModule
        Port ( Xk   : in  STD_LOGIC;
               Yk   : in  STD_LOGIC;
               Xx   : in  STD_LOGIC;
               Yx   : in  STD_LOGIC;
               Cin  : in  STD_LOGIC;
               Z    : out STD_LOGIC;
               Cout : out STD_LOGIC);
    end component;

    -- Internal result vectors for each operation and inverted operand B
    signal sadd, cin2, ssub, smul, sinc : STD_LOGIC_VECTOR (3 downto 0);
    
    -- Carry chains for addition, subtraction, and increment
    signal Cadd, Csub, Cinc : STD_LOGIC_VECTOR (4 downto 0);
    
    -- Intermediate sum signals for multiplication (truncated to 4-bit output)
    signal mulLvl1 : STD_LOGIC_VECTOR (1 downto 0); -- mulLvl1(2) omitted for 4-bit output
    signal mulLvl2 : STD_LOGIC;                     -- mulLvl2(2..1) omitted for 4-bit output
    
    -- Intermediate carry signals for multiplication (truncated to 4-bit output)
    signal CmulLvl1 : STD_LOGIC_VECTOR (2 downto 0); -- CmulLvl1(4..3) omitted for 4-bit output
    signal CmulLvl2 : STD_LOGIC;                     -- CmulLvl2(3..1) omitted for 4-bit output

begin
    -- Invert operand B for two's complement subtraction
    cin2 <= not in2;
    
    -- Initial carry-in assignments
    Cadd(0) <= Cin; -- External carry-in for addition
    Csub(0) <= '1'; -- Carry-in = 1 completes two's complement (A + NOT(B) + 1)
    Cinc(0) <= '1'; -- Carry-in = 1 performs increment (A + 0 + 1)
    
    -- Select Carry-out based on active arithmetic operation
    Cout <= Cadd(4) when sel = "01" else
            Csub(4) xor Csub(3) when sel = "10" else
            Cinc(4) when sel = "11" else
            '0';

    -- 4-bit Ripple-Carry Addition (in1 + in2)
    FA3: fullAdder port map (X => in1(3), Y => in2(3), Z => sadd(3), Cin => Cadd(3), Cout => Cadd(4));
    FA2: fullAdder port map (X => in1(2), Y => in2(2), Z => sadd(2), Cin => Cadd(2), Cout => Cadd(3));
    FA1: fullAdder port map (X => in1(1), Y => in2(1), Z => sadd(1), Cin => Cadd(1), Cout => Cadd(2));
    FA0: fullAdder port map (X => in1(0), Y => in2(0), Z => sadd(0), Cin => Cadd(0), Cout => Cadd(1));

    -- 4-bit Two's Complement Subtraction (in1 - in2)
    FS3: fullAdder port map (X => in1(3), Y => cin2(3), Z => ssub(3), Cin => Csub(3), Cout => Csub(4));
    FS2: fullAdder port map (X => in1(2), Y => cin2(2), Z => ssub(2), Cin => Csub(2), Cout => Csub(3));
    FS1: fullAdder port map (X => in1(1), Y => cin2(1), Z => ssub(1), Cin => Csub(1), Cout => Csub(2));
    FS0: fullAdder port map (X => in1(0), Y => cin2(0), Z => ssub(0), Cin => Csub(0), Cout => Csub(1));

    -- 4-bit Array Multiplication (lower 4 bits of in1 * in2)
    -- Level 1 partial products
    ML10: MultiplierModule port map (Xk => '0',    Yk => '0',    Xx => in1(0), Yx => in2(0), Cin => '0',         Z => smul(0),    Cout => CmulLvl1(0));
    ML11: MultiplierModule port map (Xk => in1(0), Yk => in2(1), Xx => in1(1), Yx => in2(0), Cin => CmulLvl1(0), Z => smul(1),    Cout => CmulLvl1(1));
    ML12: MultiplierModule port map (Xk => in1(1), Yk => in2(1), Xx => in1(2), Yx => in2(0), Cin => CmulLvl1(1), Z => mulLvl1(0), Cout => CmulLvl1(2));
    ML13: MultiplierModule port map (Xk => in1(2), Yk => in2(1), Xx => in1(3), Yx => in2(0), Cin => CmulLvl1(2), Z => mulLvl1(1));

    -- Level 2 partial products
    ML20: MultiplierModule port map (Xk => '1', Yk => mulLvl1(0), Xx => in1(0), Yx => in2(2), Cin => '0',      Z => smul(2), Cout => CmulLvl2);
    ML21: MultiplierModule port map (Xk => '1', Yk => mulLvl1(1), Xx => in1(1), Yx => in2(2), Cin => CmulLvl2, Z => mulLvl2);

    -- Level 3 partial product (MSB of 4-bit result)
    ML30: MultiplierModule port map (Xk => '1', Yk => mulLvl2, Xx => in1(0), Yx => in2(3), Cin => '0', Z => smul(3));

    -- 4-bit Increment by 1 (in1 + 1)
    FAI3: fullAdder port map (X => in1(3), Y => '0', Z => sinc(3), Cin => Cinc(3), Cout => Cinc(4));
    FAI2: fullAdder port map (X => in1(2), Y => '0', Z => sinc(2), Cin => Cinc(2), Cout => Cinc(3));
    FAI1: fullAdder port map (X => in1(1), Y => '0', Z => sinc(1), Cin => Cinc(1), Cout => Cinc(2));
    FAI0: fullAdder port map (X => in1(0), Y => '0', Z => sinc(0), Cin => Cinc(0), Cout => Cinc(1));

    -- Output multiplexer: selects arithmetic result according to sel
    -- "01" -> Addition, "10" -> Subtraction, "11" -> Multiplication, "00" -> Increment
    out1 <= sadd when sel = "01" else
            ssub when sel = "10" else
            smul when sel = "11" else
            sinc;
end Behavioral;