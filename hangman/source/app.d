import std.random;
import std.stdio;

/// This is our DB layer.
string[] words = [ "how", "now", "brown", "cow" ];


/// The game itself.
void main()
{
	auto index = uniform(0, words.length);
	writeln("Chosen word: ", words[index]);
}
