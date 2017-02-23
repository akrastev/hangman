import db;
import std.algorithm.iteration;
import std.algorithm.sorting;
import std.random;
import std.range;
import std.stdio;
import std.uni;
import ui;

/// The mutable game state.
struct GameState {
	/// The word that has to be guessed.
	string _randomWord;

	/// The letters that were guessed right.
	string _guessedRight = "";

	/// The letters that were guessed wrong.
	string _guessedWrong = "";
}

/// Take into account a single word.
///
/// @return true iff the guess was correct.
@safe bool updateGameState(char ch, ref GameState state)
{
	for (int i = 0; i < state._randomWord.length; ++i) {
		if (ch == state._randomWord[i]) {
			state._guessedRight ~= [ch];
			return true;
		}
	}
	state._guessedWrong ~= [ch];
	return false;
}

@safe unittest
{
	GameState s = { _randomWord: "how", _guessedRight: "o", _guessedWrong: "a" };
	assert(!updateGameState('c', s));
	assert("how" == s._randomWord);
	assert("o" == s._guessedRight);
	assert("ac" == s._guessedWrong);
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


/// The whole game in one function.
bool play(string randomWord)
{
	const auto charsToGuess = randomWord.getCharsInWord.length;
	auto errors = 0;

	GameState state = { randomWord };

	do {
		render(randomWord, errors, state._guessedRight, state._guessedWrong);
		const auto ch = readGuess(state._guessedRight, state._guessedWrong);

		if (!updateGameState(ch, state)) {
			++errors;
		}
	} while (errors < hangedMan.length && state._guessedRight.length < charsToGuess);

	const auto isWinning = state._guessedRight.length == charsToGuess;

	if (isWinning) {
		// Fix #4. The last render will show the guessed word.
		render(randomWord, errors, state._guessedRight, state._guessedWrong);
	}

	return isWinning;
}
