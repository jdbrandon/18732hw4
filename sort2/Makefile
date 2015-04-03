
object=sort2.o
stem=$(basename $(object))
all: prove

%.o:	%.adb %.ads $(stem).gpr
	gnatmake  $*.adb

.Phony: prove

prove: $(object)
	gnatprove -P $(stem).gpr --timeout=2000 

clean:
	rm -rf gnatprove/ $(stem).ali $(object)
