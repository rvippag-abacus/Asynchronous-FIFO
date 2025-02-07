
# Asynchronous FIFO

This repository contains a Verilog implementation of a pointer-based FIFO (First In, First Out) memory module and its corresponding testbench. The FIFO module is designed to handle data buffering with separate input and output clocks, making it suitable for asynchronous data transfer.

## Files

- `fifo_tb.v`: The testbench for the FIFO module.
- `fifo.v`: The FIFO module implementation.

## Description

### FIFO Module (`fifo.v`)

The FIFO module is parameterized by depth and data width. It uses separate clocks for input and output operations, allowing asynchronous data transfer. The module includes flags to indicate when the FIFO is full (`fifo_f`) and empty (`fifo_e`).

#### Parameters

- `DEPTH`: The depth of the FIFO (number of elements it can hold).
- `WIDTH`: The width of the data elements.

#### Ports

- `in_clk`: Clock signal for input operations.
- `out_clk`: Clock signal for output operations.
- `in_ready`: Signal indicating that input data is ready to be written to the FIFO.
- `out_ready`: Signal indicating that the output is ready to read data from the FIFO.
- `reset`: Reset signal to initialize the FIFO.
- `data_in`: Input data to be written to the FIFO.
- `data_out`: Output data read from the FIFO.
- `fifo_f`: Flag indicating that the FIFO is full.
- `fifo_e`: Flag indicating that the FIFO is empty.

### Testbench (`fifo_tb.v`)

The testbench verifies the functionality of the FIFO module by simulating various scenarios, including filling the FIFO, reading from the FIFO, interleaved write and read operations, overfilling, and over-reading the FIFO. The testbench generates waveforms for visual inspection using the `VCD` format.

## Usage

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/pointer_fifo_tb.git
    cd pointer_fifo_tb
    ```

2. Run the simulation using your preferred Verilog simulator. For example, using Icarus Verilog:
    ```sh
    iverilog -o pointer_fifo_tb pointer_fifo_tb.v
    vvp pointer_fifo_tb
    ```

3. View the waveform using a VCD viewer, such as GTKWave:
    ```sh
    gtkwave pointer_fifo_tb.vcd
    ```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Author

- rvippag-abacus
