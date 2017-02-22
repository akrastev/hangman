import std.ascii;
import std.process;
import std.stdio;
import std.string;


/// The hanged man. A picture gallery.
immutable string[] hangedMan = [
	"\n",

	"|\n" ~
	"|\n" ~
	"|\n",

	"|- - |\n" ~
	"|\n" ~
	"|\n",

	"|- - |\n" ~
	"|    |\n" ~
	"|\n",

	"|- - |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"|   \\ /\n" ~
	"|\n",

	"|- - |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"|   \\ /\n" ~
	"|    |\n" ~
	"|\n",

	"|- - |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"|   \\ /\n" ~
	"|    |\n" ~
	"|    |\n" ~
	"|    |\n" ~
	"|   /\n" ~
	"|  /\n" ~
	"|\n" ~
	"|\n",

	"|- - |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"|   \\ /\n" ~
	"|    |\n" ~
	"|    |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"|  /   \\\n" ~
	"|\n" ~
	"|\n",

	"|- - |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"|   \\ / /\n" ~
	"|    | / \n" ~
	"|    |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"|  /   \\\n" ~
	"|\n" ~
	"|\n",

	"|- - |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"| \\ \\ / /\n" ~
	"|  \\ | / \n" ~
	"|    |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"|  /   \\\n" ~
	"|\n" ~
	"|\n",


	"|- - |\n" ~
	"|   #|#\n" ~
	"| # / \\ #\n" ~
	"| \\#\\ /#/\n" ~
	"|  \\###/ \n" ~
	"|    |\n" ~
	"|    |\n" ~
	"|   / \\\n" ~
	"|  /   \\\n" ~
	"|\n" ~
	"|\n"
];


/// Extract the scene rendering.
void render(ref const string randomWord, int errors, const char[] guessed, const char[] wrong)
{
	wait(spawnShell("cls"));
	writeln(hangedMan[errors]);
	auto mask = tr(randomWord, guessed, ['_'], "c");
	write("   ");
	for (int i = 0; i < mask.length; ++i) {
		write(mask[i], " ");
	}
	writeln("   (", randomWord.length, " letters)\n");
	writeln("Right guesses: ", guessed);
	writeln("Wrong guesses: ", wrong,
	        "  (", hangedMan.length - wrong.length - 1, "/",
	        hangedMan.length - 1, " left)");
}


/// Extract the user input functionallity.
char readGuess(ref const char[] guessed, ref const char[] wrong)
{
	bool uniqueGuess;
	char[] guess;
	char ch;

	do {
		write("Guess a letter: ");
		readln(guess);

		assert(guess.length > 0);

		ch = guess[0];
		uniqueGuess = true; // assume uniqueness

		if (!ch.isAlpha || !ch.isLower) {
			writeln("Your guess must be a lower-case letter.");
			continue;
		}

		// try in guessed
		for (int i = 0; i < guessed.length; ++i) {
			if (guessed[i] == ch) {
				uniqueGuess = false;
				writeln("You already tried that and it was right.");
				break;
			}
		}

		// try in wrong
		if (uniqueGuess) {
			for (int i = 0; i < wrong.length; ++i) {
				if (wrong[i] == ch) {
					uniqueGuess = false;
					writeln("You already tried that and it was wrong.");
					break;
				}
			}
		}
	} while (!uniqueGuess || !ch.isLower || !ch.isAlpha);

	return ch;
}
