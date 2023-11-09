using System.Collections.Generic;
using DIKUArcade.Entities;

namespace SpaceTaxi_1.Level {
    public class Level {
        public static string LevelString;
        public static string[] LevelStringArr;

        public static Dictionary<char, string> SymbolDict;
        public static List<char> PlatformKeys;
        public static char[,] LevelMap;

        public static EntityContainer LevelEntities;
        public static Dictionary<char, EntityContainer> PlatformID;

        public static float PlayerStartPosX;
        public static float PlayerStartPosY;

        public List<string> Levels = new List<string> {"short-n-sweet.txt", "the-beach.txt"};
        public int LevelNumber;

        public const int MAP_WIDTH = 40;
        public const int MAP_HEIGHT = 23;

        /// <summary>
        /// The level constructor.
        /// </summary>
        public Level() {
            LevelNumber = 0;
            CreateNewLevel();
        }

        /// <summary>
        /// A method that creates a level. This is also used by NextLevel in the game constructor.
        /// </summary>
        public void CreateNewLevel() {
            FileReader.ReadLevel(Levels[LevelNumber]);
            LevelDictionary.CreateSymbolDict();
            LevelDictionary.CreatePlatformKey();
            Level2DArray.CreateLevel2DArray();
            LevelEntityContainers.CreateEntityContainers(Level.LevelMap, Level.SymbolDict);
        }
    }
}