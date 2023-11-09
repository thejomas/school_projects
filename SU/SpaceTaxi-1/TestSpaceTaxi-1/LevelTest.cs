using NUnit.Framework;
using SpaceTaxi_1;
using SpaceTaxi_1.Level;
using SpaceTaxi_1.TaxiStates;

namespace TestSpaceTaxi_1 {
    [TestFixture]
    public class LevelTest {
        [SetUp]
        public void Setup() {
            Game game = Game.GetInstance();
        }

        /// <summary>
        /// FileReder is tests with LevelStringArr.
        /// </summary>
        /// <param name="lvl"> Levelnumber </param>
        /// <param name="line"> The index of the expected line in the file </param>
        /// <param name="expline"></param>
        [TestCase(0, 0, "%#%#%#%#%#%#%#%#%#^^^^^^%#%#%#%#%#%#%#%#")]
        [TestCase(0, 22, "%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#")]
        [TestCase(1, 0, "CTTTTTTTTTTTTTTTTD^^^^^^CTTTTTTTTTTTTttt")]
        [TestCase(1, 22, "OOOOSSSeSSSSSSSSSSSeSSSSSSSOaOOOOOOOOOOO")]
        public void TestReadFile(int lvl, int line, string expline) {
            GameRunning.Level.LevelNumber = lvl;
            GameRunning.Level.CreateNewLevel();
            string actual = Level.LevelStringArr[line];
            Assert.AreEqual(expline, actual);
        }

        /// <summary>
        /// The Symbol Dictionary is tested by ensuring that the symbol returns the correct filename
        /// </summary>
        /// <param name="lvl"> LevelNumber </param>
        /// <param name="key"> The char. </param>
        /// <param name="filename"> The filename that belongs to the char. </param>
        [TestCase(0, '%', "white-square.png")]
        [TestCase(0, 'x', "white-lower-right.png")]
        [TestCase(0, 'G', "green-upper-left.png")]
        [TestCase(1, 'A', "aspargus-edge-left.png")]
        [TestCase(1, 's', "tacha-upper-right.png")]
        [TestCase(1, 'a', "emperor-square.png")]
        public void TestSymbolDict(int lvl, char key, string filename) {
            GameRunning.Level.LevelNumber = lvl;
            GameRunning.Level.CreateNewLevel();
            Assert.AreEqual(Level.SymbolDict[key], filename);
        }

        /// <summary>
        /// Checks if the platform is in the list PlatformKeys
        /// </summary>
        /// <param name="lvl"> LevelNumber </param>
        /// <param name="key"> PlatformKey </param>
        [TestCase(0, '1')]
        [TestCase(1, 'J')]
        [TestCase(1, 'i')]
        [TestCase(1, 'r')]
        public void TestPlatformKeys(int lvl, char key) {
            GameRunning.Level.LevelNumber = lvl;
            GameRunning.Level.CreateNewLevel();
            Assert.IsTrue(Level.PlatformKeys.Contains(key));
        }

        /// <summary>
        /// Tests that each entry in a line in LevelMap is correct.
        /// </summary>
        /// <param name="lvl"> LevelNumber </param>
        /// <param name="line"> Index of the line from the file </param>
        /// <param name="lvlline"> The line from the file. </param>
        [TestCase(0, 5, "#       3                           o  %")]
        [TestCase(0, 22, "%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#")]
        [TestCase(1, 4, "HIIIIIIIIIG                            B")]
        [TestCase(1, 21, "MMMMMMMeMMMMMMMMMMMeMMMMMMMMaMMMMMMMMMMM")]
        public void TestLevelMap(int lvl, int line, string lvlline) {
            GameRunning.Level.LevelNumber = lvl;
            GameRunning.Level.CreateNewLevel();
            for (int i = 0; i < lvlline.Length; i++) {
                Assert.IsTrue(Level.LevelMap[line, i] == lvlline[i]);
            }
        }
    }
}