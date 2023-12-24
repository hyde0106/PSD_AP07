library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity kasir is
    port (
        cetak : in std_logic;
        hargaItem1 : in integer;
        hargaItem2 : in integer;
        jumlahItem1 : in integer;
        jumlahItem2 : in integer;
        operasi :in std_logic;
        clock : in std_logic;
        totalHarga : out integer
    );
end entity kasir;

architecture rtl of kasir is
    type state is (importing, waiting_input, counting, counted, printing, done);
    signal current_state : state := importing;
    signal flag : std_logic;
    signal totalHargatemp : integer;
    signal totalHargatempInput : integer;
    
    signal hargaItem1Digital : std_logic_vector(15 downto 0) := (others => '0');
    signal hargaItem2Digital : std_logic_vector(15 downto 0) := (others => '0');
    signal jumlahItem1Digital : std_logic_vector(15 downto 0) := (others => '0');
    signal jumlahItem2Digital : std_logic_vector(15 downto 0) := (others => '0');
    signal totalHargaDigital : std_logic_vector(15 downto 0) := (others => '0');
    signal operasiSelected : std_logic := '0';

    component ALU is 
        port (
            operand1 : in std_logic_vector(15 downto 0);
            operand2 : in std_logic_vector(15 downto 0);
            jumlah1 : in std_logic_vector(15 downto 0); -- jumlah item 1
            jumlah2 : in std_logic_vector(15 downto 0); -- jumlah item 2
            operasi : in std_logic;
            hasil : out integer;
            clock : in std_logic 
        );
    end component ALU;
    
begin

    UUT : ALU port map (
        operand1 => hargaItem1Digital,
        operand2 => hargaItem2Digital,
        jumlah1 => jumlahItem1Digital,
        jumlah2 => jumlahItem2Digital,
        operasi => operasiSelected,
        hasil => totalHargatemp,
        clock => clock
    );

    process(clock, current_state, operasi, hargaItem1Digital, hargaItem2Digital, jumlahItem1Digital, jumlahItem2Digital, totalHargatemp) is
    begin
        if rising_edge(clock) then
            case current_state is
                when importing => -- import data dari file
                    report "Importing currently disabled";
                    current_state <= waiting_input;

                when waiting_input => -- menunggu input dari user
                    -- konversi dari integer ke std_logic_vector
                    hargaItem1Digital <= std_logic_vector(to_unsigned(hargaItem1, 16));
                    hargaItem2Digital <= std_logic_vector(to_unsigned(hargaItem2, 16));
                    jumlahItem1Digital <= std_logic_vector(to_unsigned(jumlahItem1, 16));
                    jumlahItem2Digital <= std_logic_vector(to_unsigned(jumlahItem2, 16));
                    
                    if hargaItem1Digital = "0000000000000000" and hargaItem2Digital = "0000000000000000" and jumlahItem1Digital = "0000000000000000" and jumlahItem2Digital = "0000000000000000" then
                        current_state <= waiting_input;
                    else
                        current_state <= counting;
                    end if;

                when counting => -- menghitung total harga
                    hargaItem1Digital <= hargaItem1Digital;
                    hargaItem2Digital <= hargaItem2Digital;
                    jumlahItem1Digital <= jumlahItem1Digital;
                    jumlahItem2Digital <= jumlahItem2Digital;
                    operasiSelected <= operasi;
                    current_state <= counted;
                    
                when counted => -- menampilkan total harga
                    report "Total harga: Rp  " & integer'image(totalHargatemp);

                    if cetak = '1' then
                        current_state <= printing;
                    else
                        current_state <= done;
                    end if;

                when printing => -- mencetak struk
                    report "Printing currently disabled";
                    current_state <= done;

                when done => -- proses selesai
                    current_state <= waiting_input; -- kembali meminta input
                
            end case;
        end if;
    end process;

    totalHarga <= totalHargatemp;
    
end architecture rtl;