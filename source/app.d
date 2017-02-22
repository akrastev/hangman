import db;
import std.algorithm.iteration;
import std.algorithm.sorting;
import std.random;
import std.range;
import std.stdio;
import std.uni;
import ui;

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


/// Extract the correctness test.
@safe bool isCorrectGuess(char ch, string randomWord)
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


@safe unittest
{
	assert(isCorrectGuess('w', "cow"));
	assert(!isCorrectGuess('n', "how"));
}


/// The whole game in one function.
bool play(string randomWord)
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
