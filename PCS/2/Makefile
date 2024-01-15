
# Some rules to start off for submitting code for OnlineTA
# Remember to add your report and support files (if any)
handin.zip: bomb-assembly.asm solution.txt
	@echo "!!! Remember to update the Makefile to include your report !!!"
	zip -MM $@ $^

.PHONY: onlineta
onlineta: handin.zip
	curl -F handin=@handin.zip https://pcs.incorrectness.dk/grade/week3
