//-----------------------------------------------------------------------------
// Module Name   : pulse_sensor
// Project       : ECE 211 Digital Circuits 1
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : April 2023
//-----------------------------------------------------------------------------
// Description   : Pulse sensor using the XADC A/D converter
//                 This circuit uses a simple digital comparator with hysteresis
//                 It also outputs the A/D output (digitized pulse signal) for 
//                 display on LEDs
//-----------------------------------------------------------------------------

module pulse_sensor(
    input logic clk,
    input logic rst,
    input analog_pos_in,       // pulse sensor positive input
    input analog_neg_in,      // pulse sensor negative input
    output logic [15:0] led,  // display digitized pulse sensor value
    output logic pulse        // display pulse as red LED
    );
    
    logic [15:0] di_in, do_out;
    logic        eoc_out;
    logic [4:0] channel_out;
    // the following signals are not connected to anything
    logic busy_out, drdy_out, eos_out, ot_out, vccaux_alarm_out, vccint_alarm_out;
    logic user_temp_alarm_out, alarm_out;
    logic vp_in, vn_in;  // not connected analog signals
    assign vp_in = 0;
    assign vn_in = 0;
    
    assign di_in = '0;    // not actally used here
    
    logic [11:0] adc_data;
    assign adc_data = do_out[15:4];
    
    thermometer_decode(do_out[15:12], led);
    
    pulse_fsm U_PFSM( .clk, .rst(1'b0), .din(adc_data), .pulse );
    
    xadc_wiz_0 U_ADC
          (
          .daddr_in(channel_out),    // Address bus for the dynamic reconfiguration port
          .dclk_in(clk),             // Clock input for the dynamic reconfiguration port
          .den_in(eoc_out),          // Enable Signal for the dynamic reconfiguration port
          .di_in,                    // Input data bus for the dynamic reconfiguration port
          .dwe_in(1'b0),             // Write Enable for the dynamic reconfiguration port
          .reset_in(rst),            // Reset signal for the System Monitor control logic
          .vauxp3(analog_pos_in),    // Auxiliary channel 3 - connected to JXADC pins 6, 12
          .vauxn3(analog_neg_in),
          .busy_out,                 // ADC Busy signal
          .channel_out,              // Channel Selection Outputs
          .do_out,                   // Output data bus for dynamic reconfiguration port
          .drdy_out,                 // Data ready signal for the dynamic reconfiguration port
          .eoc_out,                  // End of Conversion Signal
          .eos_out,                  // End of Sequence Signal
          .ot_out,                   // Over-Temperature alarm output
          .vccaux_alarm_out,         // VCCAUX-sensor alarm output
          .vccint_alarm_out,         //  VCCINT-sensor alarm output
          .user_temp_alarm_out,      // Temperature-sensor alarm output
          .alarm_out,                // OR'ed output of all the Alarms    
          .vp_in,                    // Dedicated Analog Input Pair
          .vn_in
          );
    
endmodule