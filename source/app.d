import std.algorithm.iteration;
import std.algorithm.sorting;
import std.process;
import std.random;
import std.range;
import std.stdio;
import vibe.d;
import vibe.http.client;


/// The whole game in one function.
void play() {
	
	/// The hanged man. A picture gallery.
	string[] hangedMan = [
		"(none)",

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
		"|   \\ /\n",

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

	string randomWord = "I hope something random comes through HTTP.";

	requestHTTP("http://www.setgetgo.com/randomword/get.php",
		(scope req) {
			req.method = HTTPMethod.GET;
		},
		(scope res) {
			randomWord = res.bodyReader.readAllUTF8();
		}
	);

	char[] charsInRandomWord;
	for (int i = 0; i < randomWord.length; ++i) {
		bool found = false;
		for (int j = 0; j < charsInRandomWord.length; ++j) {
			if (charsInRandomWord[j] == randomWord[i]) {
				found = true;
				break;
			}
		}
		if (!found) {
			charsInRandomWord ~= [randomWord[i]];
		}
	}

	auto errors = 0;
	char[] guessed;
	char[] wrong;

	do {
		wait(spawnShell("cls"));
		writeln("Hanging:\n", hangedMan[errors]);
		auto mask = tr(randomWord, guessed, ['_'], "c");
		write("The guess so far:   ");
		for (int i = 0; i < mask.length; ++i) {
			write(mask[i], " ");
		}
		writeln("   (", randomWord.length, " letters)");
		writeln("Wrong guesses: ", wrong);

		char[] guess;
		write("Guess a letter: ");
		readln(guess);

		assert(guess.length > 0);
		const char ch = guess[0];
		writeln("Got it. Guess: ", ch);

		bool found = false;
		for (int i = 0; i < randomWord.length; ++i) {
			if (randomWord[i] == ch) {
				found = true;
				break;
			}
		}

		if (!found) {
			++errors;
			wrong ~= [ch];
		} else {
			guessed ~= [ch];
		}
	} while (errors < hangedMan.length && guessed.length < charsInRandomWord.length);

	if (guessed.length == charsInRandomWord.length) {
		writeln("YOU ROCK!");
	} else {
		writeln("YOU WERE HANGED");
	}
	writeln("The word was: ", randomWord);
}

/// The game itself.
void main()
{
	play();
}
