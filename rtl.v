//======================================================
// DAY 9
// 4-BIT SHIFT REGISTER
// SYNCHRONOUS + ASYNCHRONOUS RESET
//======================================================


//======================================================
// 1. DFF WITH SYNCHRONOUS RESET
//======================================================

module dff_sync_reset(
    input clk,
    input reset,
    input d,
    output reg q
);

    always @(posedge clk) begin

        if (reset)
            q <= 1'b0;

        else
            q <= d;

    end

endmodule


//======================================================
// 2. DFF WITH ASYNCHRONOUS RESET
//======================================================

module dff_async_reset(
    input clk,
    input reset,
    input d,
    output reg q
);

    always @(posedge clk or posedge reset) begin

        if (reset)
            q <= 1'b0;

        else
            q <= d;

    end

endmodule


//======================================================
// 3. 4-BIT SYNCHRONOUS SHIFT REGISTER
//
// Direction:
//
// serial_in → Q3 → Q2 → Q1 → Q0
//======================================================

module shift_register_4bit_sync(

    input clk,
    input reset,
    input serial_in,

    output [3:0] q

);

    dff_sync_reset DFF3(
        .clk(clk),
        .reset(reset),
        .d(serial_in),
        .q(q[3])
    );


    dff_sync_reset DFF2(
        .clk(clk),
        .reset(reset),
        .d(q[3]),
        .q(q[2])
    );


    dff_sync_reset DFF1(
        .clk(clk),
        .reset(reset),
        .d(q[2]),
        .q(q[1])
    );


    dff_sync_reset DFF0(
        .clk(clk),
        .reset(reset),
        .d(q[1]),
        .q(q[0])
    );

endmodule


//======================================================
// 4. 4-BIT ASYNCHRONOUS SHIFT REGISTER
//
// Direction:
//
// serial_in → Q3 → Q2 → Q1 → Q0
//======================================================

module shift_register_4bit_async(

    input clk,
    input reset,
    input serial_in,

    output [3:0] q

);

    dff_async_reset DFF3(
        .clk(clk),
        .reset(reset),
        .d(serial_in),
        .q(q[3])
    );


    dff_async_reset DFF2(
        .clk(clk),
        .reset(reset),
        .d(q[3]),
        .q(q[2])
    );


    dff_async_reset DFF1(
        .clk(clk),
        .reset(reset),
        .d(q[2]),
        .q(q[1])
    );


    dff_async_reset DFF0(
        .clk(clk),
        .reset(reset),
        .d(q[1]),
        .q(q[0])
    );

endmodule


//======================================================
// 5. TOP MODULE
//======================================================

module shift_register_4bit_top(

    input clk,

    input reset_sync,
    input reset_async,

    input serial_in,

    output [3:0] q_sync,
    output [3:0] q_async

);

    //==================================================
    // SYNCHRONOUS SHIFT REGISTER
    //==================================================

    shift_register_4bit_sync SYNC_SHIFT(

        .clk(clk),
        .reset(reset_sync),
        .serial_in(serial_in),
        .q(q_sync)

    );


    //==================================================
    // ASYNCHRONOUS SHIFT REGISTER
    //==================================================

    shift_register_4bit_async ASYNC_SHIFT(

        .clk(clk),
        .reset(reset_async),
        .serial_in(serial_in),
        .q(q_async)

    );

endmodule
