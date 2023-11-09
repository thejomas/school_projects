##
# PMPH A1 Task 3
##
COMPILER=nvcc
FLAGS   = -O3
OLD     = -arch=compute_35
SOURCE  = wa1-task3.cu
EXEC    = a.out

default: compile run

compile:
	$(COMPILER) $(FLAGS) $(SOURCE)

old_compile:
	$(COMPILER) $(FLAGS) $(OLD) $(SOURCE)

run:
	./$(EXEC)

clean:
	rm -f ./$(EXEC)

# end
