GHDL = ghdl
ANALIZE = -a --ieee=synopsys -fexplicit #-Wc,-m32 -Wa,--32
ELABORATE = -e --ieee=synopsys -fexplicit #-Wa,--32 -Wl,-m32
RUN = -r


#--------------------------------------------------
#EDIT
NAME0 = adder.vhd
NAME1 = alu.vhd
NAME2 = dmem.vhd
NAME3 = flopr.vhd
NAME4 = imem.vhd
NAME5 = mux2.vhd
NAME6 = regfile.vhd
NAME7 = sign.vhd
NAME8 = sl2.vhd
NAME9 = datapath.vhd
NAMETB = pipeline_tb
NAME12 = fetch.vhd
NAME13 = decode.vhd
NAME14 = execute.vhd
NAME15 = memory.vhd
NAME16 = writeback.vhd
NAME17 = IF_ID.vhd
NAME18 = ID_EX.vhd
NAME19 = EX_MEM.vhd
NAME20 = MEM_WB.vhd
#--------------------------------------------------

all: vhdl

vhdl:
	$(GHDL) $(ANALIZE) $(NAME0)
	$(GHDL) $(ANALIZE) $(NAME1)
	$(GHDL) $(ANALIZE) $(NAME2)
	$(GHDL) $(ANALIZE) $(NAME3)
	$(GHDL) $(ANALIZE) $(NAME4)
	$(GHDL) $(ANALIZE) $(NAME5)
	$(GHDL) $(ANALIZE) $(NAME6)
	$(GHDL) $(ANALIZE) $(NAME7)
	$(GHDL) $(ANALIZE) $(NAME8)
	$(GHDL) $(ANALIZE) $(NAME12)
	$(GHDL) $(ANALIZE) $(NAME13)
	$(GHDL) $(ANALIZE) $(NAME14)
	$(GHDL) $(ANALIZE) $(NAME15)
	$(GHDL) $(ANALIZE) $(NAME16)
	$(GHDL) $(ANALIZE) IF_ID.vhd ID_EX.vhd EX_MEM.vhd MEM_WB.vhd
	$(GHDL) $(ANALIZE) $(NAME9)
	$(GHDL) $(ANALIZE) controller.vhd maindec.vhd aludec.vhd
	$(GHDL) $(ANALIZE) pipeline.vhd
	$(GHDL) $(ANALIZE)  pipeline_tb.vhd
	$(GHDL) $(ELABORATE) $(NAMETB)
	$(GHDL) $(RUN) pipeline_tb --stop-time=250ns --vcd=data.vcd

clean:
	rm -f *.o *.cf *.vcd $(NAMETB) *~ 
