GHDL = ghdl
ANALIZE = -a --ieee=synopsys -fexplicit
ELABORATE = -e --ieee=synopsys -fexplicit
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
NAME10 = datapath_tb.vhd
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
	$(GHDL) $(ANALIZE) $(NAME9) $(NAME10)
	$(GHDL) $(ELABORATE) datapath_tb
	$(GHDL) $(RUN) datapath_tb --stop-time=50ns --vcd=data.vcd

clean:
	rm *.s *.o *.cf *.lst *.vcd $(NAMETB)
