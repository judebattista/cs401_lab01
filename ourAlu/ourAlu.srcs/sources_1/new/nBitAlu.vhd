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
	   op : in STD_LOGIC_VECTOR( 4 downto 0 );
	   y : out STD_LOGIC_VECTOR( N-1 downto 0 ) );
end nBitAlu;

architecture Behavioral of nBitAlu is
    signal sum, aout, bout, equality : STD_LOGIC_VECTOR( N-1 downto 0 );
	signal compareBit, equalityBit : STD_LOGIC;
begin
	-- generate muxen to choose between A/~A and B/~B
	aout <= a when ( op(4) = '0' ) else not a;
    bout <= b when ( op(3) = '0' ) else not b;
    sum <= aout + bout + (op(4) or  op(3));  -- 2's complement depends on op(4) for A and op(3) for B
	compareBit <= sum(N-1);
	equality <= b-a;
	equalityBit <= equality(N-1);
	  
    process ( a, b, op(4 downto 0), sum, equality, aout, bout, compareBit, equalityBit)
    begin
        case op(4 downto 0) is 
            when "00000" => y <= aout and bout;  -- a && b
			when "01000" => y <= aout and bout;  -- a && ~b
			when "10000" => y <= aout and bout;  -- ~a && b
			when "11000" => y <= aout and bout;  -- ~a && ~b
            when "00001" => y <= aout or bout;   -- a || b
			when "01001" => y <= aout or bout;   -- a || ~b
			when "10001" => y <= aout or bout;   -- ~a || b
			when "11001" => y <= aout or bout;   -- ~a || ~b
            when "00010" => y <= sum;         -- a + b
			when "01010" => y <= sum;         -- a - b
			when "10010" => y <= sum;         -- b - a
			when "01011" => y <= (N-1 downto 1 => '0') & compareBit;                -- a < b
			when "10011" => y <= (N-1 downto 1 => '0') & compareBit;                -- a > b
			when "01100" => y <= (N-1 downto 1 => '0') & not compareBit;            -- a >= b
			when "10100" => y <= (N-1 downto 1 => '0') & not compareBit;            -- a <= b
            when "01101" => y <= (N-1 downto 1 => '0') & not(compareBit or equalityBit);      -- a == b
			when "01110" => y <= (N-1 downto 1 => '0') & (compareBit or equalityBit);     -- a != b
			when "00111" => y <= aout xor bout;  -- a xor b
			when "01111" => y <= aout xor bout;  -- a xor ~b
			when "10111" => y <= aout xor bout;  -- ~a xor b
			when "11111" => y <= aout xor bout;  -- ~a xor ~b
			when others => y <= (others => 'X');
		end case;
    end process;
end Behavioral;


-------------------------------------------------
-- a or b / a or ~b XX000
-- a and b / a and ~b XX001
-- a + b / a - b XX010
-- a < b 01011 check
-- a > b 10011 check
-- a <= b 0100 check
-- a >= b 1100 check
-- a == b 1101 check
-- a != b 1110 check
-- a xor b XX111 check
-------------------------------------------------