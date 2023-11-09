using NUnit.Framework;
using SpaceTaxi_1;
using SpaceTaxi_1.Level;
using SpaceTaxi_1.TaxiStates;

namespace TestSpaceTaxi_1 {
    public class PhysicsTest {
        [SetUp]
        public void Setup() {
            Game game = Game.GetInstance();
        }

        /// <summary>
        /// Tests that accelerator calculates the position correctly.
        /// </summary>
        /// <param name="lvl"> The level </param>
        /// <param name="up"> UpVal </param>
        /// <param name="left"> LeftBool </param>
        /// <param name="right"> RightBool </param>
        /// <param name="xPos"> The pre-calculated xPos. </param>
        /// <param name="yPos"> The pre-calculated yPos. </param>
        [TestCase(0, 0, false, false, 0, 0)]
        [TestCase(0, 1, false, false, 0.774999976f, 0.826065958f)]
        [TestCase(0, 1, false, true, 0.775020957f, 0.826065958f)]
        [TestCase(0, 1, true, false, 0.774978995f, 0.826065958f)]
        [TestCase(0, 2, false, false, 0.774999976f, 0.826107919f)]
        [TestCase(0, 2, false, true, 0.775020957f, 0.826107919f)]
        [TestCase(0, 2, true, false, 0.774978995f, 0.826107919f)]

        [TestCase(1, 0, false, false, 0, 0)]
        [TestCase(1, 1, false, false, 0.375f, 0.347805083f)]
        [TestCase(1, 1, false, true, 0.375021011f, 0.347805083f)]
        [TestCase(1, 1, true, false, 0.374978989f, 0.347805083f)]
        [TestCase(1, 2, false, false, 0.375f, 0.347847104f)]
        [TestCase(1, 2, false, true, 0.375021011f, 0.347847104f)]
        [TestCase(1, 2, true, false, 0.374978989f, 0.347847104f)]
        public void TestAccelerator(int lvl, int up, bool left, bool right, float xPos,
            float yPos) {
            LevelSelect.levelSelect(lvl);
            if (up == 0) {
                xPos = Level.PlayerStartPosX;
                yPos = Level.PlayerStartPosY;
            }
            GameRunning.Player.UpVal = up;
            GameRunning.Player.LeftBool = left;
            GameRunning.Player.RightBool = right;
            GameRunning.Player.VerticalTime = 0.001f;
            GameRunning.Player.HorizontalTime = 0.001f;
            GameRunning.Player.Move();
            Assert.AreEqual(GameRunning.Player.Shape.Position.X, xPos);
            Assert.AreEqual(GameRunning.Player.Shape.Position.Y, yPos);
        }
    }
}