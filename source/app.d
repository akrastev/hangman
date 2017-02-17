import std.random;
import std.stdio;

/// This is our DB layer.
string[] words = [ "how", "now", "brown", "cow" ];

/// The hanged man. A picture gallery.
string[] hangedMan = [
	"",

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
];

/// The game itself.
void main()
{
	auto index = uniform(0, words.length);
	writeln("Chosen word: ", words[index]);

	immutable auto errors = 5;
	writeln("Hanging:\n", hangedMan[errors]);

	char[] guess;
	write("Make a guess: ");
	readln(guess);

	assert(guess.length > 0);

	const char ch = guess[0];
	if (guess.length > 1)
	{
		writeln("The guess contained more than one character.\n" ~
		        "Taking the first character as the actual guess.");
	}

	writeln("Guess: ", ch);
}
