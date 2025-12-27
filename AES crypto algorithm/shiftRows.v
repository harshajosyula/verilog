/*
    shift rows
*/

module shiftRows(
    input wire[127:0] byteShiftedText,
    output wire[127:0] shiftedRows
);




assign shiftedRows[127:120] = byteShiftedText[127:120];
assign shiftedRows[119:112] = byteShiftedText[87:80];
assign shiftedRows[111:104] = byteShiftedText[47:40];
assign shiftedRows[103:96] = byteShiftedText[7:0];
assign shiftedRows[95:88] = byteShiftedText[95:88];
assign shiftedRows[87:80] = byteShiftedText[55:48];
assign shiftedRows[79:72] = byteShiftedText[15:8];
assign shiftedRows[71:64] = byteShiftedText[103:96];
assign shiftedRows[63:56] = byteShiftedText[63:56];
assign shiftedRows[55:48] = byteShiftedText[23:16];
assign shiftedRows[47:40] = byteShiftedText[111:104];
assign shiftedRows[39:32] = byteShiftedText[71:64];
assign shiftedRows[31:24] = byteShiftedText[31:24];
assign shiftedRows[23:16] = byteShiftedText[119:112];
assign shiftedRows[15:8] = byteShiftedText[79:72];
assign shiftedRows[7:0] = byteShiftedText[39:32];



endmodule