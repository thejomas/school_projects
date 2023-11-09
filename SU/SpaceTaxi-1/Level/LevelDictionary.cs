using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace SpaceTaxi_1.Level {
    public class LevelDictionary {
        /// <summary>
        /// Uses regular expressions to find the symbol before ")" and after the space in each line.
        /// (Matches the symbol with the file name).
        /// </summary>
            public static void CreateSymbolDict() {
            List<string> dictLines = new List<string>();
            for (int i = Level.MAP_HEIGHT + 4; i < Level.LevelStringArr.Length - 2; i++) {
                if (!string.IsNullOrWhiteSpace(Level.LevelStringArr[i])) {
                    dictLines.Add(Level.LevelStringArr[i]);
                }
            }
    
            Regex r = new Regex(@"^.(?=\))"); //Symbol before ")" and ")".
            Regex s = new Regex(@"\s(.*)"); //Rest of line.
            Level.SymbolDict = new Dictionary<char, string>();

            foreach (string line in dictLines) {
                char symbol = r.Match(line).Value[0];//First char - the char before ")".
                string fileName = s.Match(line).Value.Substring(1);
                Level.SymbolDict.Add(symbol, fileName);
            }
        }

        /// <summary>
        /// Creates a list of the characters that represent platforms.
        /// </summary>
        public static void CreatePlatformKey() {
            Level.PlatformKeys = new List<char>();
            Regex r = new Regex("Platforms:");
            Regex s = new Regex(@"\s(.*)");

            foreach (string line in Level.LevelStringArr) {
                if (!r.IsMatch(line)) {
                    continue;
                }

                string platform = s.Match(line).Value.Substring(1);
                if (platform.Length == 1) {
                    Level.PlatformKeys.Add(platform[0]);
                } else {
                    platform = platform.Replace(" ", string.Empty);
                    for (int i = 0; i < platform.Length; i += 2) {
                        Level.PlatformKeys.Add(platform[i]);
                    }
                }
                break;
            }
        }
    }
}