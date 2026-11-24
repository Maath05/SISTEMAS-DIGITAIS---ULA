----------------------------------------------------------------------------------
-- Company: UFRJ - Escola Politecnica
-- Engineer: Matheus Viana, Bernardo Elias, Julio Silva
-- 
-- Create Date:    11/18/2026 
-- Design Name:    4-bit ALU
-- Module Name:    teste2 - Behavioral 
-- Project Name:   EEL480 - Digital Systems TP1
-- Target Devices: Xilinx Spartan-3
-- Description:    Top-level Finite State Machine (FSM) controlling user input
--                 via switches and buttons, and displaying ALU output on LEDs.
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity declaration for the FSM controller
entity teste2 is
    Port ( chaves       : in  STD_LOGIC_VECTOR (3 downto 0); -- 4 input switches
           botao_A_ok   : in  STD_LOGIC;                     -- Button to confirm Operand A
           botao_B_ok   : in  STD_LOGIC;                     -- Button to confirm Operand B
           botao_Sel_ok : in  STD_LOGIC;                     -- Button to confirm Operation code
           CLK_50M      : in  STD_LOGIC;                     -- 50 MHz onboard clock
           leds         : out STD_LOGIC_VECTOR (7 downto 0); -- 8 output LEDs
           reset        : in  STD_LOGIC);                    -- Asynchronous reset button
end teste2;

architecture Behavioral of teste2 is

    -- Main ALU component declaration
    component projeto1
        Port ( in1  : in  STD_LOGIC_VECTOR (3 downto 0);
               in2  : in  STD_LOGIC_VECTOR (3 downto 0);
               out1 : out STD_LOGIC_VECTOR (3 downto 0);
               sel  : in  STD_LOGIC_VECTOR (2 downto 0));
    end component;

    -- Arithmetic unit component declaration (available for direct testing if needed)
    component projeto1Arit
        Port ( Cin  : in  STD_LOGIC;
               Cout : out STD_LOGIC;
               in1  : in  STD_LOGIC_VECTOR (3 downto 0);
               in2  : in  STD_LOGIC_VECTOR (3 downto 0);
               out1 : out STD_LOGIC_VECTOR (3 downto 0);
               sel  : in  STD_LOGIC_VECTOR (1 downto 0));
    end component;

    -- FSM state definition (simplified flow without timed rotation)
    type estados is (recebeA, recebeB, recebeSel, mostrarOut);
    signal estadoAtual : estados := recebeA;

    -- Internal registers for operands, ALU output, and operation selector
    signal A, B, out2 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal sel2       : STD_LOGIC_VECTOR (2 downto 0) := "000";

begin

    -- Sequential process for the Finite State Machine
    Maquina: process(CLK_50M, reset) is
    begin
        -- Asynchronous reset returns FSM to the initial state
        if (reset = '1') then
            estadoAtual <= recebeA;
        elsif (CLK_50M'event and CLK_50M = '1') then
            case estadoAtual is
                -- State 1: Capture 4-bit Operand A from switches
                when recebeA =>
                    A <= chaves;
                    leds(7 downto 5) <= "000";    -- State indicator LEDs
                    leds(4) <= '0';
                    leds(3 downto 0) <= chaves;   -- Mirror switch values on lower LEDs
                    if (botao_A_ok = '1') then
                        estadoAtual <= recebeB;
                    end if;

                -- State 2: Capture 4-bit Operand B from switches
                when recebeB =>
                    B <= chaves;
                    leds(7 downto 5) <= "001";    -- State indicator LEDs
                    leds(4) <= '0';
                    leds(3 downto 0) <= chaves;   -- Mirror switch values on lower LEDs
                    if (botao_B_ok = '1') then
                        estadoAtual <= recebeSel;
                    end if;

                -- State 3: Capture 3-bit Operation Selector from switches
                when recebeSel =>
                    sel2 <= chaves(2 downto 0);
                    leds(7 downto 5) <= "010";              -- State indicator LEDs
                    leds(4) <= '0';
                    leds(3 downto 0) <= chaves(2 downto 0) & '0'; -- Display selector on LEDs
                    if (botao_Sel_ok = '1') then
                        estadoAtual <= mostrarOut;
                    end if;

                -- State 4: Hold and display ALU result until reset is pressed
                when mostrarOut =>
                    leds(7 downto 5) <= "111";    -- Result state indicator
                    leds(4) <= sel2(2);           -- Indicates Logic ('1') or Arithmetic ('0')
                    leds(3 downto 0) <= out2;     -- Display 4-bit ALU result

                -- Fallback state
                when others =>
                    estadoAtual <= recebeA;
            end case;
        end if;
    end process;

    -- Instantiate the 4-bit ALU connected to the FSM registers
    PR1: projeto1 port map (in1 => A, in2 => B, out1 => out2, sel => sel2(2 downto 0));

end Behavioral;