library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
    port(
        clock : in std_logic
    );
end entity testbench;

architecture rtl of testbench is

    component kasir is
        port(
            cetak : in std_logic;
            hargaItem1 : in integer;
            hargaItem2 : in integer;
            jumlahItem1 : in integer;
            jumlahItem2 : in integer;
            operasi :in std_logic;
            clock : in std_logic;
            totalHarga : out integer
        );
        end component kasir;

    signal cetak : std_logic := '0';
    signal hargaItem1 : integer := 0;
    signal hargaItem2 : integer := 0;
    signal jumlahItem1 : integer := 0;
    signal jumlahItem2 : integer := 0;
    signal operasi : std_logic := '0';
    signal totalHarga : integer := 0;
    
begin
    
    UUT : kasir port map (
        cetak => cetak,
        hargaItem1 => hargaItem1,
        hargaItem2 => hargaItem2,
        jumlahItem1 => jumlahItem1,
        jumlahItem2 => jumlahItem2,
        operasi => operasi,
        clock => clock,
        totalHarga => totalHarga
    );

    process 
    begin
        
        hargaItem1 <= 5;
        hargaItem2 <= 4;
        jumlahItem1 <= 3;
        jumlahItem2 <= 2;
        operasi <= '1';
        wait for 10 ns;

        hargaItem1 <= 5;
        hargaItem2 <= 4;
        jumlahItem1 <= 3;
        jumlahItem2 <= 2;
        operasi <= '0';

        report "Simulation finished" severity note;
        wait;

    end process;
end architecture rtl;