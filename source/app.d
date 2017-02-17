import std.random;
import std.range;
import std.stdio;

/// This is our DB layer.
string[] words = [ "how", "now", "brown", "cow" ];

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
];

/// The game itself.
void main()
{
	auto index = uniform(0, words.length);
	auto word = words[index];
	writeln("Chosen word: ", word);

	auto errors = 0;
	writeln("Hanging:\n", hangedMan[errors]);

    auto wordStat = repeat("_", word.length).join(' ');
	writeln("Guess the word: ",  wordStat);

	char[] guess;
	write("Guess a letter: ");
	readln(guess);

	assert(guess.length > 0);
	const char ch = guess[0];
	writeln("Got it. Guess: ", ch);
}
