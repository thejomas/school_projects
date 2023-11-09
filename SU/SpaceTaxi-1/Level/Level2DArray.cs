namespace SpaceTaxi_1.Level {
    public class Level2DArray {
        /// <summary>
        /// Creates a 2D array of individual characters from the ASCII map from LevelStringArr.
        /// </summary>
        public static void CreateLevel2DArray() {
            Level.LevelMap = new char[Level.MAP_HEIGHT, Level.MAP_WIDTH];
            for (int i = 0; i < Level.MAP_HEIGHT; i++) {
                for (int j = 0; j < Level.MAP_WIDTH; j++) {
                    Level.LevelMap[i, j] = Level.LevelStringArr[i][j];
                }
            }
        }
    }
}