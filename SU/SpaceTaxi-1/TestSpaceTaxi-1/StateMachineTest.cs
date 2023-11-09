using DIKUArcade.State;
using NUnit.Framework;
using SpaceTaxi_1;
using SpaceTaxi_1.TaxiStates;

namespace TestSpaceTaxi_1 {
    public class StateMachineTest {
        [SetUp]
        public void SetUp() {
            Game game = Game.GetInstance();
        }

        /// <summary>
        /// Tests that SwitchState of StateMachine works correctly
        /// </summary>
        /// <param name="state"> The state to switch to. </param>
        [TestCase(GameStateType.GameOver)]
        [TestCase(GameStateType.GamePaused)]
        [TestCase(GameStateType.GameRunning)]
        [TestCase(GameStateType.LevelSelect)]
        [TestCase(GameStateType.MainMenu)]
        public void TestStateMachine(GameStateType state) {
            StateMachine.GetInstance().SwitchState(state);
            IGameState curState = StateMachine.GetInstance().ActiveState;
            Assert.AreNotEqual(state, curState);
        }
    }
}