import vibe.d;
import vibe.http.client;


version(unittest)
@safe string getRandomWord()
{
	return "hownowbrowncow";
}
else
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
	
	return randomWord.toLower;
}

/// In the unit test version a fixed string is returned.
///
/// We might need other strings as well to test corner cases.
@safe unittest
{
	assert("hownowbrowncow" == getRandomWord());
}
