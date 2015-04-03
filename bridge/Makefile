object=bridge_controller.o
stem=$(basename $(object))

all: prove

%.o:	%.adb %.ads %.gpr
	gnatmake  $*.adb

.Phony: prove clean

prove: $(object)	
	gnatprove -P $(stem).gpr
clean:
	@rm -rf gnatprove/ $(object) $(stem).ali
