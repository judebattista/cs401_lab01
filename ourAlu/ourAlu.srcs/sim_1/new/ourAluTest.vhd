--------------------------------------------------------------------------------
-- Module Name:   Example of a programmed test bench 
-- Project Name:  Test all inputs for 16 bit and gate
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;        -- use this instead of STD_LOGIC_ARITH
 
ENTITY testAlu IS
END testAlu;
 
ARCHITECTURE behavior OF testAlu IS 
    COMPONENT nBitAlu
        generic (N : integer := 4);
        port ( a, b: in STD_LOGIC_VECTOR( N-1 downto 0 );
                op: in STD_LOGIC_VECTOR;
                y: out STD_LOGIC_VECTOR( N-1 downto 0 )
           );
    END COMPONENT;
   --Inputs
   signal a : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
   signal b : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
   signal op : STD_LOGIC_VECTOR(4 downto 0);
   
   --Outputs
   signal y : STD_LOGIC_VECTOR(3 downto 0) := (others => 'X');
BEGIN
    uut: nBitAlu PORT MAP ( a => a, b => b, op => op, y => y );

    stim_proc: process
        begin
            -- AND
            a <= "1010";
            wait for 1 ns;
            b <= "1011";
            wait for 1 ns;
            op <= "00000";
            wait for 1 ns;
            assert y = "1010" report "Failed A and B";
            op <= "01000";
            wait for 1 ns;
            assert y = "0000" report "Failed A and ~B";
            op <= "10000";
            wait for 1 ns;
            assert y = "0001" report "Failed ~A and B";
            op <= "11000";
            wait for 1 ns;
            assert y = "0100" report "Failed ~A and ~B";
            
            -- OR
            op <= "00001";
            wait for 1 ns;
            assert y = "1011" report "Failed A or B";
            op <= "01001";
            wait for 1 ns;
            assert y = "1110" report "Failed A or ~B";
            op <= "10001";
            wait for 1 ns;
            assert y = "1111" report "Failed ~A or B";
            op <= "11001";
            wait for 1 ns;
            assert y = "0101" report "Failed ~A or ~B";
            
            -- SUM
            op <= "00010";
            wait for 1 ns;
            assert y = "0101" report "Failed A + B";
            op <= "01010";
            wait for 1 ns;
            assert y = "1111" report "Failed A - B";
            op <= "10010";
            wait for 1 ns;
            assert y = "0001" report "Failed B - A";
            
            -- LT / GT
            op <= "01011";
            wait for 1 ns;
            assert y = "0001" report "Failed A < B";
            op <= "10011";
            wait for 1 ns;
            assert y = "0000" report "Failed A > B";
            op <= "10000";
            wait for 1 ns;
            assert y = "0001" report "Failed ~A and B";
            op <= "11000";
            wait for 1 ns;
            assert y = "0100" report "Failed ~A and ~B";
            
            -- LTE / GTE
            op <= "01100";
            wait for 1 ns;
            assert y = "0000" report "Failed A >= B (<)";
            b <= "1010";
            wait for 1 ns;
            assert y = "0001" report "Failed A >= B (==)";
            op <= "10100";
            wait for 1 ns;
            assert y = "0001" report "Failed A <= B (==)";
            b <= "1011";
            wait for 1 ns;
            assert y = "0001" report "Failed A <= B (<)";
            
            -- ==
            op <= "01101";
            wait for 1 ns;
            assert y = "0000" report "Failed A == B (!=)";
            b <= "1010";
            wait for 1 ns;
            assert y = "0001" report "Failed A == B (==)";
            b <= "1011";
            wait for 1 ns;

            -- !=
            op <= "01110";
            wait for 1 ns;
            assert y = "0001" report "Failed A != B (!=)";
            b <= "1010";
            wait for 1 ns;
            assert y = "0000" report "Failed A != ~B (==)";
            b <= "1011";
            wait for 1 ns;
                        
            -- XOR
            op <= "00111";
            wait for 1 ns;
            assert y = "0001" report "Failed A xor B";
            op <= "01111";
            wait for 1 ns;
            assert y = "1110" report "Failed A xor ~B";
            op <= "10111";
            wait for 1 ns;
            assert y = "1110" report "Failed ~A xor B";
            op <= "11111";
            wait for 1 ns;
            assert y = "0001" report "Failed ~A xor ~B";
            
            wait; -- Need this line to keep the sim from looping
    end process;
END;
