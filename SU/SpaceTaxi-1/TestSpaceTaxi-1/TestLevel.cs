using NUnit.Framework;
using SpaceTaxi_1;
using SpaceTaxi_1.Level;
using SpaceTaxi_1.TaxiStates;

namespace TestSpaceTaxi_1 {
    [TestFixture]
    public class Tests {
        [SetUp]
        public void Setup() {
            Game game = new Game();
        }

        // LEVEL TESTS -----------------------------------------------------------------------------
        // Testing the player start position (found in level)
        [TestCase(0)]
        [TestCase(1)]
        public void TestPlayerStartPos(int i) {
            GameRunning._level.levelNumber = i;
            GameRunning._level.CreateNewLevel();
            float expPosX = Level.playerStartPosX;
            float expPosY = Level.playerStartPosY;
            LevelSelect.levelSelect(i);
            float curPosX = GameRunning._player.Entity.Shape.Position.X;
            float curPosY = GameRunning._player.Entity.Shape.Position.Y;
            Assert.AreEqual(curPosX, expPosX);
            Assert.AreEqual(curPosY, expPosY);
        }

        // FileReader tests on levelStringArr
        [TestCase(0, 0, "%#%#%#%#%#%#%#%#%#^^^^^^%#%#%#%#%#%#%#%#")]
        [TestCase(0, 22, "%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#")]
        [TestCase(1, 0, "CTTTTTTTTTTTTTTTTD^^^^^^CTTTTTTTTTTTTttt")]
        [TestCase(1, 22, "OOOOSSSeSSSSSSSSSSSeSSSSSSSOaOOOOOOOOOOO")]
        public void TestReadFile(int lvl, int line, string expline) {
            GameRunning._level.levelNumber = lvl;
            GameRunning._level.CreateNewLevel();
            string actual = Level.levelStringArr[line];
            Assert.AreEqual(expline, actual);
        }

        // LevelDictionary tests on SymbolDict
        [TestCase(0, '%', "white-square.png")]
        [TestCase(0, 'x', "white-lower-right.png")]
        [TestCase(0, 'G', "green-upper-left.png")]
        [TestCase(1, 'A', "aspargus-edge-left.png")]
        [TestCase(1, 's', "tacha-upper-right.png")]
        [TestCase(1, 'a', "emperor-square.png")]
        public void TestSymbolDict(int lvl, char key, string filename) {
            GameRunning._level.levelNumber = lvl;
            GameRunning._level.CreateNewLevel();
            Assert.AreEqual(Level.SymbolDict[key], filename);
        }

        // LevelDictionary tests on PlatformKeys
        [TestCase(0, '1')]
        [TestCase(1, 'J')]
        [TestCase(1, 'i')]
        [TestCase(1, 'r')]
        public void TestPlatformKeys(int lvl, char key) {
            GameRunning._level.levelNumber = lvl;
            GameRunning._level.CreateNewLevel();
            Assert.IsTrue(Level.PlatformKeys.Contains(key));
        }

        // Level2DArray
        [TestCase(0, 5, "#       3                           o  %")]
        [TestCase(0, 22, "%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#")]
        [TestCase(1, 4, "HIIIIIIIIIG                            B")]
        [TestCase(1, 21, "MMMMMMMeMMMMMMMMMMMeMMMMMMMMaMMMMMMMMMMM")]
        public void TestLevelMap(int lvl, int line, string lvlline) {
            GameRunning._level.levelNumber = lvl;
            GameRunning._level.CreateNewLevel();
            for (int i = 0; i < lvlline.Length; i++) {
                Assert.IsTrue(Level.levelMap[line, i] == lvlline[i]);
            }
        }
    }
}