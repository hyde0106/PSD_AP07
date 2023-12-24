library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity ALU is
    port (
            operand1 : in std_logic_vector(15 downto 0);
            operand2 : in std_logic_vector(15 downto 0);
            jumlah1 : in std_logic_vector(15 downto 0); -- jumlah item 1
            jumlah2 : in std_logic_vector(15 downto 0); -- jumlah item 2
            operasi : in std_logic;
            hasil : out integer;
            clock : in std_logic
    );
end entity ALU;

architecture rtl of ALU is
    signal jumlah1Int : integer;
    signal jumlah2Int : integer;
    signal operand1int : integer;
    signal operand2int : integer;
    signal temp : integer;
    signal operand1Total : integer;
    signal operand2Total : integer;
begin
    
    perhitungan : process(clock, operand1, operand2)
    begin

        -- konversi input menjadi integer
        jumlah1Int <= to_integer(unsigned(jumlah1));
        jumlah2Int <= to_integer(unsigned(jumlah2));
        operand1int <= to_integer(unsigned(operand1));
        operand2int <= to_integer(unsigned(operand2));

        if rising_edge(clock) then
            operand1Total <= operand1int * jumlah1Int;
            operand2Total <= operand2int * jumlah2Int;

            case operasi is
                when '0' => temp <= operand1Total + operand2Total;
                when '1' => temp <= operand1Total - operand2Total;
                when others => temp <= 0;
            end case;

        end if;
    end process perhitungan;

    hasil <= temp;

end architecture rtl;