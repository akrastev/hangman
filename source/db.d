import vibe.d;
import vibe.http.client;


version(unittest)
string getRandomWord()
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
