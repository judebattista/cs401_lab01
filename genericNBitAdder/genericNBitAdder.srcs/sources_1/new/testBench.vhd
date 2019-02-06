--------------------------------------------------------------------------------
-- Module Name:   Example of a programmed test bench 
-- Project Name:  Test all inputs for 16 bit and gate
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;        -- use this instead of STD_LOGIC_ARITH
 
ENTITY testAdder IS
END testAdder;
 
ARCHITECTURE behavior OF testAdder IS 
    COMPONENT adder
        generic (N : integer := 4);
        port ( a, b: in STD_LOGIC_VECTOR( N-1 downto 0 );
                cin: in STD_LOGIC;
                sum: out STD_LOGIC_VECTOR( N-1 downto 0 );
                cout: out STD_LOGIC );
    END COMPONENT;
   --Inputs
   signal a : std_logic_vector(3 downto 0) := (others => '0');
   signal b : std_logic_vector(3 downto 0) := (others => '0');
   signal cin : std_logic;
   --Outputs
   signal sum : std_logic_vector(3 downto 0) := (others => '0');
   signal cout : std_logic;
   signal intSum : integer;
BEGIN
   uut: adder PORT MAP ( a => a, b => b, cin => cin, sum => sum, cout => cout );
 
  stim_proc: process
      variable i: INTEGER range 0 to 15; 
   begin		
      for i in 0 to 15 loop
          a <= std_logic_vector(to_unsigned(i, 4));
          for j in 0 to 15 loop
            b <= std_logic_vector(to_unsigned(j, 4));
            -- cin = 0
            cin <= '0';
            wait for 5 ns;
            intSum <= to_integer(unsigned(sum));
            assert intSum = (i + j) mod 16 report "Failed for " &integer'image(i) & " and " & integer'image(j)& " and cin = 0";
            -- cin = 1
            --cin <= '0';
            --wait for 5 ns;
            -- convert y to int
            -- assert that y = i + j + cin
          end loop;
      end loop;
      wait;
   end process;
END;
