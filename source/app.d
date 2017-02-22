import db;
import gl;
import std.stdio;

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
