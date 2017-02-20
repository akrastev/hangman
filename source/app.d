import std.algorithm.iteration;
import std.algorithm.sorting;
import std.process;
import std.random;
import std.range;
import std.stdio;
import vibe.d;
import vibe.http.client;


/// Extract getting the random word.
string getRandomWord()
{
	string randomWord = "I hope something random comes through HTTP.";

	requestHTTP("http://www.setgetgo.com/randomword/get.php",
		(scope req) {
			req.method = HTTPMethod.GET;
		},
		(scope res) {
			randomWord = res.bodyReader.readAllUTF8();
		}
	);
	
	return randomWord;
}


/// Extract the generating of a char set.
@safe char[] getCharsInWord(string randomWord)
{
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

	return charsInRandomWord;
}

/// Simple test of the convert-to-set function.
@safe unittest
{
	assert("how" == getCharsInWord("how"));
	assert("now" == getCharsInWord("nownnn"));
}

	
/// The hanged man. A picture gallery.
immutable string[] hangedMan = [
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


/// Extract the scene rendering.
void render(ref const string randomWord, int errors, const char[] guessed, const char[] wrong)
{
	wait(spawnShell("cls"));
	writeln(hangedMan[errors]);
	auto mask = tr(randomWord, guessed, ['_'], "c");
	write("The guess so far:   ");
	for (int i = 0; i < mask.length; ++i) {
		write(mask[i], " ");
	}
	writeln("   (", randomWord.length, " letters)");
	writeln("Right guesses: ", guessed);
	writeln("Wrong guesses: ", wrong);
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

		writeln("Got it. Guess: ", ch);

		uniqueGuess = true; // assume uniqueness

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
	} while (!uniqueGuess);

	return ch;
}


/// Extract the correctness test.
bool isCorrectGuess(char ch, ref const string randomWord)
{
	bool found = false;
	for (int i = 0; i < randomWord.length; ++i) {
		if (randomWord[i] == ch) {
			found = true;
			break;
		}
	}

	return found;
}


/// The whole game in one function.
bool play(ref const string randomWord)
{
	const char[] charsInRandomWord = getCharsInWord(randomWord);

	auto errors = 0;
	char[] guessed;
	char[] wrong;

	do {
		render(randomWord, errors, guessed, wrong);
		char ch = readGuess(guessed, wrong);

		if (isCorrectGuess(ch, randomWord)) {
			guessed ~= [ch];
		} else {
			++errors;
			wrong ~= [ch];
		}
	} while (errors < hangedMan.length && guessed.length < charsInRandomWord.length);

	const bool isWinning = guessed.length == charsInRandomWord.length;

	if (isWinning) {
		// Fix #4. The last render will show the guessed word.
		render(randomWord, errors, guessed, wrong);
	}

	return isWinning;
}

/// The game itself.
version(unittest)
void main() {}
else
void main()
{
	immutable string randomWord = getRandomWord();
	if (play(randomWord)) {
		writeln("YOU ROCK!");
	} else {
		writeln("YOU WERE HANGED");
		writeln("The word was: ", randomWord);
	}
}
