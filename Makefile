## Simple make file, It does NOT check for interdependencies of modules.
## It probably is best to do make clean; make if you change a module.

## Make files are extremely picky about syntax. 
## Indentations have to be done with tabulators!
## Absolutely nothing can follow a continuation backslash.

## List main program module last
## 
SOURCES = precise.f90 \
	io.f90 \
	vtkxmlmod.f90 \
	fifthpanel.f90 \
	fourthconst.f90 \
	A.f90 \
	slae.f90 \
	p1.f90

## Define name of main program
PROGRAM = p1

# Compiler
FF = g95

# Delete program
# Linux
RM = rm -f
# DOSe
#RM = del

## Compiler options
# for the Intel Fortran 90 compiler
# CFLAGS = -c -fast -heap-arrays

# for the g95 compiler
CFLAGS = -c -O2

#Linker Options
# for the Intel Fortran 90 compiler
# LDFLAGS = -fast -heap-arrays

# for the g95 compiler
LDFLAGS = -O2


## Probably no changes necessary below this line
OBJECTS = $(SOURCES:.f90=.o)

all: $(SOURCES) $(PROGRAM)


$(PROGRAM): $(OBJECTS)
	$(FF) $(LDFLAGS) $(OBJECTS) -o $@

$(OBJECTS): %.o: %.f90
	$(FF) $(CFLAGS) $< -o $@

clean:
	$(RM) $(OBJECTS) *.mod 

realclean:
	$(RM) $(OBJECTS) *.mod $(PROGRAM)