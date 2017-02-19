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
@safe char[] getCharsInWord(ref const string randomWord)
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
char readGuess()
{
	char[] guess;
	write("Guess a letter: ");
	readln(guess);

	assert(guess.length > 0);
	const char ch = guess[0];
	writeln("Got it. Guess: ", ch);

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
		char ch = readGuess();

		if (isCorrectGuess(ch, randomWord)) {
			guessed ~= [ch];
		} else {
			++errors;
			wrong ~= [ch];
		}
	} while (errors < hangedMan.length && guessed.length < charsInRandomWord.length);

	return guessed.length == charsInRandomWord.length;

}

/// The game itself.
void main()
{
	immutable string randomWord = getRandomWord();
	if (play(randomWord)) {
		writeln("YOU ROCK!");
	} else {
		writeln("YOU WERE HANGED");
	}
	writeln("The word was: ", randomWord);
}
