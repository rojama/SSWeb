package com.app.electric;

//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

import net.wimpi.modbus.Modbus;
import net.wimpi.modbus.ModbusIOException;
import net.wimpi.modbus.io.BytesInputStream;
import net.wimpi.modbus.io.BytesOutputStream;
import net.wimpi.modbus.io.ModbusSerialTransport;
import net.wimpi.modbus.msg.ModbusMessage;
import net.wimpi.modbus.msg.ModbusRequest;
import net.wimpi.modbus.msg.ModbusResponse;
import net.wimpi.modbus.util.ModbusUtil;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class ModbusRTUTranTCP extends ModbusSerialTransport {
    private InputStream m_InputStream;
    private OutputStream m_OutputStream;
    private byte[] m_InBuffer;
    private BytesInputStream m_ByteIn;
    private BytesOutputStream m_ByteInOut;
    private BytesOutputStream m_ByteOut;
    private byte[] lastRequest = null;

    public ModbusRTUTranTCP() {
    }

    public void writeMessage(ModbusMessage msg) throws ModbusIOException {
        try {
            BytesOutputStream var3 = this.m_ByteOut;
            synchronized(this.m_ByteOut) {
                this.clearInput();
                this.m_ByteOut.reset();
                msg.setHeadless();
                msg.writeTo(this.m_ByteOut);
                int len = this.m_ByteOut.size();
                int[] crc = ModbusUtil.calculateCRC(this.m_ByteOut.getBuffer(), 0, len);
                this.m_ByteOut.writeByte(crc[0]);
                this.m_ByteOut.writeByte(crc[1]);
                len = this.m_ByteOut.size();
                byte[] buf = this.m_ByteOut.getBuffer();
                this.m_OutputStream.write(buf, 0, len);
                this.m_OutputStream.flush();
                if(Modbus.debug) {
                    System.out.println("Sent: " + ModbusUtil.toHex(buf, 0, len));
                }

                if(super.m_Echo) {
                    this.readEcho(len);
                }

                this.lastRequest = new byte[len];
                System.arraycopy(buf, 0, this.lastRequest, 0, len);
            }
        } catch (Exception var8) {
            throw new ModbusIOException("I/O failed to write");
        }
    }

    public ModbusRequest readRequest() throws ModbusIOException {
        throw new RuntimeException("Operation not supported.");
    }

    public void clearInput() throws IOException {
        if(this.m_InputStream.available() > 0) {
            int len = this.m_InputStream.available();
            byte[] buf = new byte[len];
            this.m_InputStream.read(buf, 0, len);
            if(Modbus.debug) {
                System.out.println("Clear input: " + ModbusUtil.toHex(buf, 0, len));
            }
        }

    }

    public ModbusResponse readResponse() throws ModbusIOException {
        boolean done = false;
        ModbusResponse response = null;
        boolean var3 = false;

        try {
            do {
                BytesInputStream var4 = this.m_ByteIn;
                synchronized(this.m_ByteIn) {
                    int uid = this.m_InputStream.read();
                    if(uid == -1) {
                        throw new IOException("Error reading response");
                    }

                    int fc = this.m_InputStream.read();
                    this.m_ByteInOut.reset();
                    this.m_ByteInOut.writeByte(uid);
                    this.m_ByteInOut.writeByte(fc);
                    response = ModbusResponse.createModbusResponse(fc);
                    response.setHeadless();
                    this.getResponse(fc, this.m_ByteInOut);
                    int dlength = this.m_ByteInOut.size() - 2;
                    if(Modbus.debug) {
                        System.out.println("Response: " + ModbusUtil.toHex(this.m_ByteInOut.getBuffer(), 0, dlength + 2));
                    }

                    this.m_ByteIn.reset(this.m_InBuffer, dlength);
                    int[] crc = ModbusUtil.calculateCRC(this.m_InBuffer, 0, dlength);
                    if(ModbusUtil.unsignedByteToInt(this.m_InBuffer[dlength]) != crc[0] || ModbusUtil.unsignedByteToInt(this.m_InBuffer[dlength + 1]) != crc[1]) {
                        throw new IOException("CRC Error in received frame: " + dlength + " bytes: " + ModbusUtil.toHex(this.m_ByteIn.getBuffer(), 0, dlength));
                    }

                    this.m_ByteIn.reset(this.m_InBuffer, dlength);
                    if(response != null) {
                        response.readFrom(this.m_ByteIn);
                    }

                    done = true;
                }
            } while(!done);

            return response;
        } catch (Exception var10) {
            System.err.println("Last request: " + ModbusUtil.toHex(this.lastRequest));
            System.err.println(var10.getMessage());
            throw new ModbusIOException("I/O exception - failed to read");
        }
    }

    public void prepareStreams(InputStream in, OutputStream out) throws IOException {
        this.m_InputStream = in;
        this.m_OutputStream = out;
        this.m_ByteOut = new BytesOutputStream(256);
        this.m_InBuffer = new byte[256];
        this.m_ByteIn = new BytesInputStream(this.m_InBuffer);
        this.m_ByteInOut = new BytesOutputStream(this.m_InBuffer);
    }

    public void close() throws IOException {
        this.m_InputStream.close();
        this.m_OutputStream.close();
    }

    private void getResponse(int fn, BytesOutputStream out) throws IOException {
        int bc = 1;
        int bc2 = 1;
        int bcw = 1;
        int inpBytes = 0;
        byte[] inpBuf = new byte[256];

        try {
            switch(fn) {
                case 1:
                case 2:
                case 3:
                case 4:
                case 12:
                case 17:
                case 20:
                case 21:
                case 23:
                    bc = this.m_InputStream.read();
                    out.write(bc);
                    //this.setReceiveThreshold(bc + 2);
                    inpBytes = this.m_InputStream.read(inpBuf, 0, bc + 2);
                    out.write(inpBuf, 0, inpBytes);
                    //super.m_CommPort.disableReceiveThreshold();
                    if(inpBytes != bc + 2) {
                        System.out.println("Error: looking for " + (bc + 2) + " bytes, received " + inpBytes);
                    }
                    break;
                case 5:
                case 6:
                case 11:
                case 15:
                case 16:
                    //this.setReceiveThreshold(6);
                    inpBytes = this.m_InputStream.read(inpBuf, 0, 6);
                    out.write(inpBuf, 0, inpBytes);
                    //super.m_CommPort.disableReceiveThreshold();
                    break;
                case 7:
                case 8:
                    //this.setReceiveThreshold(3);
                    inpBytes = this.m_InputStream.read(inpBuf, 0, 3);
                    out.write(inpBuf, 0, inpBytes);
                    //super.m_CommPort.disableReceiveThreshold();
                case 9:
                case 10:
                case 13:
                case 14:
                case 18:
                case 19:
                default:
                    break;
                case 22:
                    //this.setReceiveThreshold(8);
                    inpBytes = this.m_InputStream.read(inpBuf, 0, 8);
                    out.write(inpBuf, 0, inpBytes);
                    //super.m_CommPort.disableReceiveThreshold();
                    break;
                case 24:
                    bc = this.m_InputStream.read();
                    out.write(bc);
                    bc2 = this.m_InputStream.read();
                    out.write(bc2);
                    bcw = ModbusUtil.makeWord(bc, bc2);
                    //this.setReceiveThreshold(bcw + 2);
                    inpBytes = this.m_InputStream.read(inpBuf, 0, bcw + 2);
                    out.write(inpBuf, 0, inpBytes);
                    //super.m_CommPort.disableReceiveThreshold();
            }

        } catch (IOException var9) {
            //super.m_CommPort.disableReceiveThreshold();
            throw new IOException("getResponse serial port exception");
        }
    }
}
