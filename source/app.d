import std.random;
import std.range;
import std.stdio;
import vibe.d;
import vibe.http.client;

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

	string randomWord = "I hope something random comes through HTTP.";

	requestHTTP("http://www.setgetgo.com/randomword/get.php",
		(scope req) {
			req.method = HTTPMethod.GET;
		},
		(scope res) {
			randomWord = res.bodyReader.readAllUTF8();
		}
	);

	writeln("Random word: ", randomWord);

	auto errors = 0;
	writeln("Hanging:\n", hangedMan[errors]);

    auto wordStat = repeat("_", word.length).join(' ');
	writeln("Guess the word: ",  wordStat);

	//char[] guess = "guess";
	const char[] guess = "boo";
	write("Guess a letter: ");
	// readln(guess);

	assert(guess.length > 0);
	const char ch = guess[0];
	writeln("Got it. Guess: ", ch);
}
