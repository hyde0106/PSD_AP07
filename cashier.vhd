LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL; -- TextIO for file operations

ENTITY cashier IS
END ENTITY;

ARCHITECTURE Behavioral OF cashier IS
    -- Prices hardcoded as constants
    CONSTANT price_indomie : INTEGER := 3500;
    CONSTANT price_minyak : INTEGER := 13000;
    CONSTANT price_beras : INTEGER := 15000;
    CONSTANT price_gulajawa : INTEGER := 18000;

    -- File I/O
    FILE input_file : text;
    FILE output_file : text;
    -- signal eof : boolean := false;

BEGIN
    PROCESS
        VARIABLE line_buffer : line;
        VARIABLE item_name : STRING(1 TO 20);
        VARIABLE total : INTEGER := 0;
        VARIABLE unit_price : INTEGER := 0;
        VARIABLE quantity : INTEGER := 0;
        VARIABLE line_text : STRING(1 TO 200);
        VARIABLE input_line : line;
        VARIABLE output_line : line;
        VARIABLE eof : BOOLEAN := false;
        VARIABLE is_list_start : BOOLEAN := false;
        VARIABLE idx : INTEGER;
        VARIABLE space_found : BOOLEAN;
        VARIABLE item_str : STRING(1 TO 20);
        VARIABLE qty_str : STRING(1 TO 10);

    BEGIN
        -- Open the input file
        file_open(input_file, "C:\Users\ASUS\OneDrive - UNIVERSITAS INDONESIA\Tugas Kuliah\SEMESTER 3\PSD\Proyek akhir\input.txt", read_mode); -- ini gua ganti pake file path
        file_open(output_file, "C:\Users\ASUS\OneDrive - UNIVERSITAS INDONESIA\Tugas Kuliah\SEMESTER 3\PSD\Proyek akhir\Receipt.txt", write_mode); -- ini juga sama gua ganti pake filepath

        -- Write the receipt header
        write(output_line, STRING'("RECEIPT BELANJA"));
        writeline(output_file, output_line);
        write(output_line, STRING'("-----------------------------"));
        writeline(output_file, output_line);

        -- Ini tambahan gaming
        -- Check if the file is empty or at EOF immediately upon opening
        IF endfile(input_file) THEN
            eof := true;
        END IF;

        -- Read input file line by line 
        WHILE NOT eof LOOP
            readline(input_file, input_line);
            -- Detect end of file
            IF endfile(input_file) THEN
                eof := true;
                EXIT;
            END IF;

            -- Convert the 'line' to a 'STRING' variable
            -- This might need adjustment for different VHDL versions -- Convert the 'line' to a 'STRING' variable

            -- Check for 'List Belanja' heading
            -- read(line_buffer, line_text);

            -- IF is_list_start THEN
            --     -- Parse and process the item and quantity
            --     -- ... Parsing logic here ...

            --     -- Calculate total for the item
            --     total := total + (unit_price * quantity);

            --     -- Write item and quantity to the receipt
            --     write(output_line, item_name & " " & INTEGER'image(quantity));
            --     writeline(output_file, output_line);
            -- END IF;

            IF line_text(1 TO 30) = "-------ISI DIBAWAH SINI-------" then
                is_list_start := true;
            ELSIF is_list_start THEN
                -- Reset parsing variables
                space_found := false;
                item_str := (OTHERS => ' ');
                qty_str := (OTHERS => ' ');

                -- Parsing logic
                idx := 0;
                FOR i IN 1 TO line_text'length LOOP
                    IF line_text(i) = ' ' THEN
                        idx := i;
                        space_found := true;
                        EXIT; --exit loop ketika ada space
                    ELSE
                        item_str(i) := line_text(i); -- nama itemnya 
                    END IF;
                END LOOP;

                -- IF space_found THEN
                --     qty_str := line_text(idx + 1 TO line_text'length); -- Extract quantity string
                --     -- Convert qty_str to integer
                --     quantity := 0; -- Reset quantity
                --     FOR i IN 1 TO qty_str'length LOOP
                --         IF qty_str(i) >= '0' AND qty_str(i) <= '9' THEN
                --             quantity := quantity * 10 + CHARACTER'pos(qty_str(i)) - CHARACTER'pos('0');
                --         END IF;
                --     END LOOP;
                -- END IF;

                IF space_found THEN
                    FOR i IN idx + 1 TO line_text'length LOOP
                        qty_str(i - idx) := line_text(i); -- Extracting quantity
                    END LOOP;

                    -- Convert qty_str to integer
                    quantity := 0; -- Reset quantity
                    FOR i IN 1 TO qty_str'length LOOP
                        IF qty_str(i) >= '0' AND qty_str(i) <= '9' THEN
                            quantity := quantity * 10 + CHARACTER'pos(qty_str(i)) - CHARACTER'pos('0');
                        END IF;
                    END LOOP;
                END IF;

                -- Identify the item and set unit_price
                IF item_str(1 to 6) = "MINYAK" THEN
                    unit_price := price_minyak;
                ELSIF item_str(1 to 7) = "INDOMIE" THEN
                    unit_price := price_indomie;
                ELSIF item_str(1 to 5) = "BERAS" THEN
                    unit_price := price_beras;
                ELSIF item_str(1 to 8) = "GULAJAWA" THEN
                    unit_price := price_gulajawa;
                END IF;

                -- Calculate total for the item
                total := total + (unit_price * quantity);

                -- Write item and quantity to the receipt
                write(output_line, item_str & " " & INTEGER'image(unit_price * quantity));
                writeline(output_file, output_line);
                -- For simplicity, let's assume the item_name and quantity are read correctly
                -- Here you would put the logic to identify the item and set the unit_price

                -- Calculate total for the item
                -- total := total + (unit_price * quantity);

                -- -- Write item and quantity to the receipt
                -- write(output_line, item_name & " " & INTEGER'image(quantity));
                -- writeline(output_file, output_line);
            END IF;
        END LOOP;

        -- Write the total to the receipt
        write(output_line, STRING'("TOTAL BELANJA = ") & INTEGER'image(total));
        writeline(output_file, output_line);
        write(output_line, STRING'("-----------------------------"));
        writeline(output_file, output_line);

        -- Close the files
        file_close(input_file);
        file_close(output_file);

        WAIT;
    END PROCESS;
END Behavioral;