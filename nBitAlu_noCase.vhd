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
	   y : out STD_LOGIC_VECTOR( N-1 downto 0 ) );
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
		if op(2 downto 0) = "000" then
			y <= a and bout;  						-- a && b  /  a && ~b
		elsif op(2 downto 0) = "001" then
			y <= a or bout;   						-- a || b  /  a || ~b
		elsif op(2 downto 0) = "010" then 
			y <= sum;         							-- a + b  /  a - b
		elsif op(3 downto 0) = "1011" then
			y <= (N-1 downto 1 => '0') & ltbit;                 -- a < b
		elsif op(3 downto 0) = "1100" then
			y <= (N-1 downto 1 => '0') & not ltbit;             -- a >= b
		elsif op(3 downto 0) = "0111" then
			y <= (N-1 downto 1 => '0') & gtbit;                 -- a > b
		elsif op(3 downto 0) = "0100" then
			y <= (N-1 downto 1 => '0') & not gtbit;             -- a <= b
		elsif op(3 downto 0) = "1101" then
			y <= (N-1 downto 1 => '0') & not (ltbit or gtbit);  -- a == b
		elsif op(3 downto 0) = "1110" then
			y <= (N-1 downto 1 => '0') & (ltbit or gtbit);      -- a != b
		end if;
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