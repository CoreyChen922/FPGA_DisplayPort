----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz< 
-- 
-- Module Name: scrambler_reset_inserter - Behavioral
--
-- Description: Replaces one in 512 Blank Start (BS) symbols with 
--              a Scrambler Reset (SR).
--
----------------------------------------------------------------------------------
-- FPGA_DisplayPort from https://github.com/hamsternz/FPGA_DisplayPort
------------------------------------------------------------------------------------
-- The MIT License (MIT)
-- 
-- Copyright (c) 2015 Michael Alan Field <hamster@snap.net.nz>
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
------------------------------------------------------------------------------------
----- Want to say thanks? ----------------------------------------------------------
------------------------------------------------------------------------------------
--
-- This design has taken many hours - 3 months of work. I'm more than happy
-- to share it if you can make use of it. It is released under the MIT license,
-- so you are not under any onus to say thanks, but....
-- 
-- If you what to say thanks for this design either drop me an email, or how about 
-- trying PayPal to my email (hamster@snap.net.nz)?
--
--  Educational use - Enough for a beer
--  Hobbyist use    - Enough for a pizza
--  Research use    - Enough to take the family out to dinner
--  Commercial use  - A weeks pay for an engineer (I wish!)
--------------------------------------------------------------------------------------
--  Ver | Date       | Change
--------+------------+---------------------------------------------------------------
--  0.1 | 2015-09-17 | Initial Version
------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scrambler_reset_inserter is
        port ( 
            clk        : in  std_logic;
            in_data0   : in  std_logic_vector(7 downto 0);
            in_data0k  : in  std_logic;
            in_data1   : in  std_logic_vector(7 downto 0);
            in_data1k  : in  std_logic;
            out_data0  : out std_logic_vector(7 downto 0);
            out_data0k : out std_logic;
            out_data1  : out std_logic_vector(7 downto 0);
            out_data1k : out std_logic
        );
end entity;

architecture arch of scrambler_reset_inserter is
    signal   bs_count : unsigned(8 downto 0) := (others => '0');
    constant BS       : std_logic_vector(8 downto 0) := "110111100";   -- K28.5
    constant SR       : std_logic_vector(8 downto 0) := "100011100";   -- K28.0
begin

process(clk)
    begin
        if rising_edge(clk) then
            out_data0k <= in_data0k;
            out_data0  <= in_data0;
            
            out_data1k <= in_data1k;
            out_data1  <= in_data1;

            ------------------------------------------------
            -- Subsitute every 513nd Blank start (BS) symbol
            -- with a Scrambler Reset (SR) symbol. 
            ------------------------------------------------
            if in_data0k = '1' and in_data0 = BS(7 downto 0) then
                if bs_count = 511 then
                    out_data0 <= SR(7 downto 0);
                end if;
                bs_count <= bs_count + 1;
            end if;

            if in_data1k = '1' and in_data1 = BS(7 downto 0) then
                if bs_count = 511 then
                    out_data1 <= SR(7 downto 0);
                end if;
                bs_count <= bs_count + 1;
            end if;
        end if;
    end process;
end architecture;