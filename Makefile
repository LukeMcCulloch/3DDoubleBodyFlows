##########################################################################################

# Specify library locations here (add or remove "#" marks to comment/uncomment lines for your platform)

########################################################################################

TARGET = flowsolver
src = src/
build = build/
bin = bin/
CC = gfortran
LD = gfortran
CFLAGS = -c -O3 -I./bin
LFLAGS = -O3 -march=native -ffast-math -funroll-loops -I./bin
# CFLAGS = -O3 -Wall -Werror -ansi -pedantic  -I./include -I./src
# LFLAGS = -O3 -Wall -Werror -ansi -pedantic 
LIBS = 

########################################################################################
## !! Do not edit below this line


# SOURCES := $(wildcard $(src)*.f90)
SOURCES = $(src)precise.f90 \
	$(src)io.f90 \
	$(src)vtkxmlmod.f90 \
	$(src)fifthpanel.f90 \
	$(src)fourthconst.f90 \
	$(src)A.f90 \
	$(src)slae.f90 \
	$(src)p1.f90

OBJECTS := $(addprefix $(src),$(notdir $(SOURCES:.f90=.o)))

all: $(SOURCES) $(TARGET)



$(TARGET): $(OBJECTS)
	$(CC) $(LFLAGS) $(OBJECTS) -o $(bin)$@  
	mv *.mod build

$(OBJECTS): %.o: %.f90
	$(CC) $(CFLAGS) $< -o $@



clean:
	rm -f $(OBJECTS)
	rm -f $(build)*.mod

	
realclean:
	rm -f $(build)$(OBJECTS)
	rm -f $(build)*.mod
	rm -f $(bin)$(TARGET)