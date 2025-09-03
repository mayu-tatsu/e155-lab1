// led_blinker.sv
//
// This module leverages the Lattice iCE40 UP5K's internal high-speed oscillator
// to generate a 2 Hz blink rate on an output LED. It is written using modern
// SystemVerilog syntax, including the `logic` data type and `always_ff` blocks.

module led_blinker (
    output logic led // The LED output
);

    // ====================================================================
    // Parameters
    // ====================================================================
    // Define the frequency of the internal oscillator. The UP5K's HFOSC
    // runs at approximately 48 MHz.
    parameter int CLK_FREQ_HZ = 48_000_000;
    
    // Define the desired blink frequency in Hz.
    parameter int BLINK_FREQ_HZ = 2;

    // Calculate the number of clock cycles for half a blink period.
    // A 2 Hz blink rate means a full period of 0.5 seconds (2Hz = 1/0.5s).
    // The LED is ON for 0.25s and OFF for 0.25s.
    // Cycles for half period = (CLK_FREQ_HZ / BLINK_FREQ_HZ) / 2
    localparam int HALF_PERIOD_CYCLES = (CLK_FREQ_HZ / BLINK_FREQ_HZ) / 2;

    // Determine the width of the counter needed to count up to HALF_PERIOD_CYCLES.
    // The width is calculated using the log2 of the value.
    localparam int COUNTER_WIDTH = $clog2(HALF_PERIOD_CYCLES);

    // ====================================================================
    // Internal Signals
    // ====================================================================
    logic [COUNTER_WIDTH-1:0] counter = 0;
    logic internal_clk;

    // ====================================================================
    // Primitive Instantiation
    // ====================================================================
    // Instantiate the Lattice iCE40 high-speed oscillator primitive.
    // The UP5K features a 48 MHz oscillator that can be enabled and used.
    HSOSC u_hfosc ( // Changed from SB_HFOSC to HSOSC as requested
        .CLKHFPU (internal_clk) // Output clock enable (always on in this case)
    );

    // ====================================================================
    // Sequential Logic
    // ====================================================================
    // Use an `always_ff` block to describe the synchronous logic,
    // triggered by the positive edge of the internal high-speed clock.
    always_ff @(posedge internal_clk) begin
        // Check if the counter has reached the half-period cycle count.
        if (counter >= (HALF_PERIOD_CYCLES - 1)) begin
            // Toggle the LED state.
            led <= ~led;
            
            // Reset the counter.
            counter <= 0;
        end else begin
            // Increment the counter.
            counter <= counter + 1;
        end
    end

endmodule