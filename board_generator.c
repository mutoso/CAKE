#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <stdbool.h>
#include <regex.h>

bool contains_letter_twice(char* string, char letter)
{
	int count = 0;
	for (size_t i = 0; i < strlen(string); i++)
	{
		if (string[i] == letter)
		{
			count++;
		}
	}
	return count > 2;
}

bool contains_letter(char* string, char letter)
{
	int count = 0;
	for (size_t i = 0; i < strlen(string); i++)
	{
		if (string[i] == letter)
		{
			count++;
		}
	}
	return count != 0;
}


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

	/* go back to the beginning of file */
	fseek(file, 0, SEEK_SET);

	/* get random lines*/
	srand(time(NULL));
	for (i = 0; i < 9; i++)
	{
		lines[i] = rand() % line_count;
		//printf("%d\n", lines[i]);
	}

	// for each of the nine characters
	for (i = 0; i < 9; i++)
	{
		// selected letter to add to board
		char letter = '\0';
		// for each line
		// j = line counter
		for (int j = 0; fgets(line, sizeof(line), file); j++)
		{
			// remove newline at end of line
			if (line[strlen(line)-1] == '\n')
			{
				line[strlen(line)-1] = '\0';
			}
			// skip over empty words
			if (strlen(line) == 0)
			{
				lines[i]++;
			}
			else 
			{
				letter = line[rand() % strlen(line)];
				for (int k = 0; contains_letter_twice(board, letter) || k < 100; k++)
				{
					letter = line[rand() % strlen(line)];
				}
				if (j == lines[i])
				{
					break;
				}
			}
		}
		line[strlen(line)-1] = '\0';
		//printf("%s\n", line);
		board[i] = letter;
		/* go back to the beginning of file */
		fseek(file, 0, SEEK_SET);
	}

	char unique_board_letters[100] = {'\0'};
	for (size_t i = 0; i < strlen(board); i++)
	{
		if (!contains_letter(unique_board_letters, board[i]))
		{
			sprintf(unique_board_letters, "%s%c", unique_board_letters, board[i]);
		}
	}

	puts(unique_board_letters);
	char pattern[100] = {'\0'};
	strcat(pattern, "^[");
	strcat(pattern, unique_board_letters);
	strcat(pattern, "]+$");
	printf("%s\n", pattern);

	regex_t regex;
	int rc = regcomp(&regex, pattern, REG_EXTENDED);
	if (rc != 0) {
	    fprintf(stderr, "Failed to compile regex\n");
	    return 1;
	}

	/* go back to the beginning of file */
	fseek(file, 0, SEEK_SET);

	/* for each line*/
	while (fgets(line, sizeof(line), file))
	{
		// remove newline at end of line
		if (line[strlen(line)-1] == '\n')
		{
			line[strlen(line)-1] = '\0';
		}

		rc = regexec(&regex, line, 0, NULL, 0);
		if (rc == 0 && strlen(line) >= 4)
		{
			puts(line);
		}
	}
}
