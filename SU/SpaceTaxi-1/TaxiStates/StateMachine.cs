using DIKUArcade.EventBus;
using DIKUArcade.State;

namespace SpaceTaxi_1.TaxiStates {
    public class StateMachine : IGameEventProcessor<object> {
        private static StateMachine instance;
        public IGameState ActiveState { get; set; }

        /// <summary>
        /// Returns the current StateMachine instance
        /// </summary>
        public static StateMachine GetInstance() {
            return StateMachine.instance ?? (StateMachine.instance = new StateMachine());
        }

        private StateMachine() {
            TaxiBus.GetBus().Subscribe(GameEventType.GameStateEvent, this);
            TaxiBus.GetBus().Subscribe(GameEventType.InputEvent, this);
            ActiveState = GameRunning.GetInstance();
            ActiveState = MainMenu.GetInstance();
        }

        /// <summary>
        /// Switches the states of the statemachine.
        /// </summary>
        public void SwitchState(GameStateType stateType) {
            switch (stateType) {
            case GameStateType.MainMenu:
                ActiveState = MainMenu.GetInstance();
                break;

            case GameStateType.GameRunning:
                ActiveState = GameRunning.GetInstance();
                break;

            case GameStateType.GamePaused :
                ActiveState = GamePaused.GetInstance();
                break;

            case GameStateType.GameOver:
                ActiveState = GameOver.GetInstance();
                break;

            case GameStateType.LevelSelect:
                ActiveState = LevelSelect.GetInstance();
                break;
            }

        }

        /// <summary>
        /// Processes different events.
        /// </summary>
        /// <param name="eventType"> The GameEventType of the event. </param>
        /// <param name="gameEvent"> The GameEvent object. </param>
        public void ProcessEvent(GameEventType eventType, GameEvent<object> gameEvent) {
            if (eventType == GameEventType.InputEvent) {
                ActiveState.HandleKeyEvent(gameEvent.Message, gameEvent.Parameter1);
            }

            if (eventType.Equals(GameEventType.GameStateEvent) && gameEvent.Message ==
                "CHANGE_STATE") {
                SwitchState(StateTransformer.TransformStringToState(gameEvent.Parameter1));
            }
        }
    }
}