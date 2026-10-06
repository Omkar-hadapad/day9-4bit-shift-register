//======================================================
// DAY 9 TESTBENCH
// 4-BIT SHIFT REGISTER
//======================================================

module day9_tb;

    //==================================================
    // INPUTS
    //==================================================

    reg clk;

    reg reset_sync;
    reg reset_async;

    reg serial_in;


    //==================================================
    // OUTPUTS
    //==================================================

    wire [3:0] q_sync;
    wire [3:0] q_async;


    //==================================================
    // DUT
    //==================================================

    shift_register_4bit_top DUT(

        .clk(clk),

        .reset_sync(reset_sync),
        .reset_async(reset_async),

        .serial_in(serial_in),

        .q_sync(q_sync),
        .q_async(q_async)

    );


    //==================================================
    // CLOCK
    // 10 ns PERIOD
    //==================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    //==================================================
    // TEST
    //==================================================

    initial begin

        //================================================
        // INITIAL VALUES
        //================================================

        reset_sync  = 1'b0;
        reset_async = 1'b0;

        serial_in = 1'b0;


        //================================================
        // INITIAL RESET
        //================================================

        #2;

        reset_sync  = 1'b1;
        reset_async = 1'b1;

        #3;

        reset_sync  = 1'b0;
        reset_async = 1'b0;


        //================================================
        // SHIFT 1
        //================================================

        serial_in = 1'b1;

        #10;

        $display(
            "SHIFT 1: SERIAL=%b Q_SYNC=%b Q_ASYNC=%b",
            serial_in,
            q_sync,
            q_async
        );


        //================================================
        // SHIFT 0
        //================================================

        serial_in = 1'b0;

        #10;

        $display(
            "SHIFT 0: SERIAL=%b Q_SYNC=%b Q_ASYNC=%b",
            serial_in,
            q_sync,
            q_async
        );


        //================================================
        // SHIFT 1
        //================================================

        serial_in = 1'b1;

        #10;

        $display(
            "SHIFT 1: SERIAL=%b Q_SYNC=%b Q_ASYNC=%b",
            serial_in,
            q_sync,
            q_async
        );


        //================================================
        // SHIFT 1
        //================================================

        serial_in = 1'b1;

        #10;

        $display(
            "SHIFT 1: SERIAL=%b Q_SYNC=%b Q_ASYNC=%b",
            serial_in,
            q_sync,
            q_async
        );


        //================================================
        // ASYNCHRONOUS RESET TEST
        //================================================

        $display("======================================");
        $display("ASYNC RESET TEST");
        $display("======================================");

        reset_async = 1'b1;

        #1;

        $display(
            "ASYNC RESET ASSERTED WITHOUT CLOCK: Q_ASYNC=%b",
            q_async
        );

        reset_async = 1'b0;


        //================================================
        // SHIFT AFTER ASYNC RESET
        //================================================

        serial_in = 1'b1;

        #10;

        $display(
            "AFTER ASYNC RESET: Q_ASYNC=%b",
            q_async
        );


        //================================================
        // SYNCHRONOUS RESET TEST
        //================================================

        $display("======================================");
        $display("SYNC RESET TEST");
        $display("======================================");

        reset_sync = 1'b1;

        #2;

        $display(
            "BEFORE CLOCK EDGE: Q_SYNC=%b",
            q_sync
        );

        #3;

        $display(
            "AFTER CLOCK EDGE: Q_SYNC=%b",
            q_sync
        );

        reset_sync = 1'b0;


        //================================================
        // FINAL SHIFT
        //================================================

        serial_in = 1'b0;

        #10;

        $display(
            "FINAL SHIFT: Q_SYNC=%b Q_ASYNC=%b",
            q_sync,
            q_async
        );


        //================================================
        // END
        //================================================

        $display("======================================");
        $display("DAY 9 TEST COMPLETE");
        $display("======================================");

        $finish;

    end


    //==================================================
    // CONTINUOUS MONITOR
    //==================================================

    initial begin

        $monitor(
            "TIME=%0t CLK=%b SYNC_RST=%b ASYNC_RST=%b SERIAL=%b Q_SYNC=%b Q_ASYNC=%b",
            $time,
            clk,
            reset_sync,
            reset_async,
            serial_in,
            q_sync,
            q_async
        );

    end


    //==================================================
    // WAVEFORM
    //==================================================

    initial begin

        $dumpfile("day9.vcd");

        $dumpvars(0, day9_tb);

    end

endmodule
