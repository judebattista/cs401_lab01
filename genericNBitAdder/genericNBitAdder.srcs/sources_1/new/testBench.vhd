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
   signal carryVector : std_logic_vector(0 downto 0) := (others => '0');
BEGIN
   uut: adder PORT MAP ( a => a, b => b, cin => cin, sum => sum, cout => cout );
 
  stim_proc: process
      variable i: INTEGER range 0 to 15; 
   begin		
      for i in 0 to 15 loop
          a <= std_logic_vector(to_unsigned(i, 4));
          for j in 0 to 15 loop
            b <= std_logic_vector(to_unsigned(j, 4));
            for k in 0 to 1 loop
                carryVector <= std_logic_vector(to_unsigned(k, 1));
                wait for 1 ns;
                cin <= carryVector(0);
                wait for 1 ns;
                intSum <= to_integer(unsigned(sum));
                wait for 1 ns;
                assert intSum = (i + j + k) mod 16 report "Failed intSum for " & integer'image(i) & " and " & integer'image(j)& " and cin = " & integer'image(k) & ". intSum was " & integer'image(intSum);
                if (i + j + k > 15) then
                    assert cout = '1' report "Failed cout for " & integer'image(i) & " and " & integer'image(j)& " and cin = " & integer'image(k) & ". intSum was " & integer'image(intSum);
                else
                    assert cout = '0' report "Failed cout for " & integer'image(i) & " and " & integer'image(j)& " and cin = " & integer'image(k) & ". intSum was " & integer'image(intSum);
                end if;
            end loop;
          end loop;
      end loop;
      wait;
   end process;
END;
