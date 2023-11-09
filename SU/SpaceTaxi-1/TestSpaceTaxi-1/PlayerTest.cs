using NUnit.Framework;
using SpaceTaxi_1;
using SpaceTaxi_1.Level;
using SpaceTaxi_1.TaxiStates;

namespace TestSpaceTaxi_1 {
    public class PlayerTest {
        [SetUp]
        public void SetUp() {
            Game game = Game.GetInstance();
            Player player = Player.GetInstance();
        }

        /// <summary>
        /// Testing that the start position is set correctly.
        /// </summary>
        /// <param name="lvl"> The level to test. </param>
        [TestCase(0)]
        [TestCase(1)]
        public void TestPlayerStartPos(int lvl) {
            GameRunning.Level.LevelNumber = lvl;
            GameRunning.Level.CreateNewLevel();
            float expPosX = Level.PlayerStartPosX;
            float expPosY = Level.PlayerStartPosY;
            LevelSelect.levelSelect(lvl);
            float curPosX = GameRunning.Player.Entity.Shape.Position.X;
            float curPosY = GameRunning.Player.Entity.Shape.Position.Y;
            Assert.AreEqual(curPosX, expPosX);
            Assert.AreEqual(curPosY, expPosY);
        }

        /// <summary>
        /// Tests that the values are changed correctly in AddExplosions.
        /// </summary>
        /// <param name="up"> UpVal. </param>
        /// <param name="left"> LeftBool. </param>
        /// <param name="right"> RightBool. </param>
        [TestCase(0, false, false)]
        [TestCase(0, true, false)]
        [TestCase(0, false, true)]
        [TestCase(0, true, true)]
        [TestCase(1, false, false)]
        [TestCase(1, true, false)]
        [TestCase(1, false, true)]
        [TestCase(1, true, true)]
        [TestCase(2, false, false)]
        [TestCase(2, true, false)]
        [TestCase(2, false, true)]
        [TestCase(2, true, true)]
        public void TestAddExplosions(int up, bool left, bool right) {
            GameRunning.Player.UpVal = up;
            GameRunning.Player.LeftBool = left;
            GameRunning.Player.RightBool = right;
            GameRunning.Player.AddExplosions(0.1f, 0.1f, 0.1f, 0.1f);
            GameRunning.Player.Move();
            Assert.AreEqual(GameRunning.Player.UpVal, 1);
            Assert.IsFalse(GameRunning.Player.LeftBool);
            Assert.IsFalse(GameRunning.Player.RightBool);
        }

        /// <summary>
        /// Tests that choose orientation chooses the right photo.
        /// </summary>
        /// <param name="up"> UpVal. </param>
        /// <param name="Left"> LeftBool. </param>
        /// <param name="Right"> RightBool. </param>
        /// <param name="orientation"> Orientation of the taxi. </param>
        [TestCase(1, true, false, Orientation.Left)]
        [TestCase(1, false, true, Orientation.Right)]
        [TestCase(1, false, false, Orientation.Left)]
        [TestCase(1, false, false, Orientation.Right)]
        [TestCase(2, true, false, Orientation.Left)]
        [TestCase(2, false, true, Orientation.Right)]
        [TestCase(2, false, false, Orientation.Left)]
        [TestCase(2, false, false, Orientation.Right)]
        public void TestChooseOrientation(int up, bool Left, bool Right, Orientation orientation) {
            int arrElm = 0;
            GameRunning.Player.UpVal = up;
            int lr = 0;
            GameRunning.Player.LeftBool = Left;
            GameRunning.Player.RightBool = Right;
            GameRunning.Player.TaxiOrientation = orientation;

            if (orientation == Orientation.Right) {
                lr = 1;
            }

            if (up == 1 && (GameRunning.Player.LeftBool || GameRunning.Player.RightBool)) {
                arrElm = 0;
            } else if (up == 2 && (GameRunning.Player.LeftBool || GameRunning.Player.RightBool)) {
                arrElm = 2;
            } else if (up == 2 && !(GameRunning.Player.LeftBool || GameRunning.Player.RightBool)) {
                arrElm = 1;
            }
            GameRunning.Player.ChooseOrientation();

            if (!(GameRunning.Player.LeftBool || GameRunning.Player.RightBool) && up == 1) {
                Assert.AreEqual(GameRunning.Player.Entity.Image, Player.images[lr]);
            } else {
                Assert.AreEqual(GameRunning.Player.Entity.Image, Player.imageStrides[lr, arrElm]);
            }
        }
    }
}