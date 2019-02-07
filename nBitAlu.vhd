-------------------------------------------------
-- Module Name:    nBitAlu - Behavioral 
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;        -- use this instead of STD_LOGIC_ARITH

entity nBitAlu is
    generic ( N : integer := 32 );
    port ( a, b : in STD_LOGIC_VECTOR( N-1 downto 0 );
	   op : in STD_LOGIC_VECTOR( 3 downto 0 );
	   y : inout STD_LOGIC_VECTOR( N-1 downto 0 ) );
end nBitAlu;

architecture Behavioral of nBitAlu is
    signal sum, bout, uselessSum : STD_LOGIC_VECTOR( N-1 downto 0 );
	signal gtbit, ltbit : STD_LOGIC;
begin
    bout <= b when ( op(3) = '0' ) else not b;
    sum <= a + bout + op(3);  -- 2's complement depends on op(3)
	ltbit <= sum(N-1);
	uselessSum <= b - a;  -- only used when op(3) == 1 and only used for inequalities
	gtbit <= uselessSum(N-1);
	         
    process ( a, b, op(3 downto 0), sum, bout, ltbit, gtbit )
    begin
		y <= (others => 'X');  -- y starts all X's, then if a valid op code is given, it gets overwritten
        case op(2 downto 0) is 
            when "000" => y <= a and bout;  -- a && b  /  a && ~b
            when "001" => y <= a or bout;   -- a || b  /  a || ~b
            when "010" => y <= sum;         -- a + b  /  a - b
			when others => y <= y;
		end case;
		
		case op(3 downto 0) is
			when "1011" => y <= (N-1 downto 1 => '0') & ltbit;                 -- a < b
			when "1100" => y <= (N-1 downto 1 => '0') & not ltbit;             -- a >= b
			when "0111" => y <= (N-1 downto 1 => '0') & gtbit;                 -- a > b
			when "0100" => y <= (N-1 downto 1 => '0') & not gtbit;             -- a <= b
			when "1101" => y <= (N-1 downto 1 => '0') & not (ltbit or gtbit);  -- a == b
			when "1110" => y <= (N-1 downto 1 => '0') & (ltbit or gtbit);      -- a != b
			when others => y <= y;
		end case;
    end process;
end Behavioral;


-------------------------------------------------
-- a or b / a or ~b X000
-- a and b / a and ~b X001
-- a + b / a - b X010
-- a < b 1011 check
-- a > b 0111 check
-- a <= b 0100 check
-- a >= b 1100 check
-- a == b 1101 check
-- a != b 1110 check
-------------------------------------------------