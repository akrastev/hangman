import db;
import gl;
import ui;

/// The game itself.
void main()
{
	immutable string randomWord = getRandomWord();
	if (play(randomWord)) {
		reportSuccess();
	} else {
		reportFailure(randomWord);
	}
}
