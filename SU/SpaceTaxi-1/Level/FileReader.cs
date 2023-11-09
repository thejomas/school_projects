using System.IO;

namespace SpaceTaxi_1.Level {
    public class FileReader {
        /// <summary>
        /// Adds all the content from the level file to LevelString, creates a string array with
        /// each line, and adds the lines with the symbol keys to LevelDict.
        /// </summary>
        /// <param name="name"> The same as in the constructor. </param>
        public static void ReadLevel(string name) {
            Level.LevelString = File.ReadAllText(Path.Combine("../../Levels", name));
            Level.LevelStringArr = Level.LevelString.Split('\n');
            for (int i = 0; i < Level.LevelStringArr.Length; i++) {
                Level.LevelStringArr[i] = Level.LevelStringArr[i].Trim('\r');
            }
        }
    }
}