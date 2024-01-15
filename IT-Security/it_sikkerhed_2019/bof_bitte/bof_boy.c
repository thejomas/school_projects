#include <stdio.h>
#include <string.h>
#include <stdlib.h>
void boy(){
	int key = 0xcafebabe;
	char bof[32];
	printf("Bof me bitte:\n");
	gets(bof);	// Is gets safe? Eh, who worries about safety!
	if(key == 0xdeadbeef){
		printf("One free shell coming right up:\n");
		system("/bin/sh");
	}
	else{
		printf("Nah, no shell for you!\n");
		return 0;
	}
}
int main(int argc, char* argv[]){
	if (argc != 1) {
		printf("No need for any arguments (yet), try again...");
		return 0;
	}
	boy();
	return 0;
}
