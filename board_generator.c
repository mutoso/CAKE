#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

int main()
{
	FILE* file = fopen("dictionary.txt", "r");
	char line[10] = {'\0'};

	int lines[9];
	int line_count = 0;
	char board[10] = {'\0'};
	int i;

	/* for each line*/
	while (fgets(line, sizeof(line), file))
	{
		line_count++;
	}

	/* go back to the beginning of file*/
	fseek(file, 0, SEEK_SET);

	/* get random lines*/
	srand(time(NULL));
	for (i = 0; i < 9; i++)
	{
		lines[i] = rand() % line_count;
		printf("%d\n", lines[i]);
	}

	for (i = 0; i < 9; i++)
	{
		int j = 0;
		while (fgets(line, sizeof(line), file))
		{
			j++;
			if (j == i)
				break;
		}
		board[i] = line[rand() % strlen(line)];
	}
	printf("%s", board);
}
