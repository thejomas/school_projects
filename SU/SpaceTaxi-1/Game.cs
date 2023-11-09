using System.Collections.Generic;
using DIKUArcade;
using DIKUArcade.EventBus;
using DIKUArcade.Timers;
using SpaceTaxi_1.TaxiStates;

namespace SpaceTaxi_1 {
    public class Game : IGameEventProcessor<object> {
        private static Game instance;

        private static StateMachine stateMachine;

        public static GameTimer GameTimer;
        public Window Win;

        private GameEventBus<object> eventBus;

        public static Game GetInstance() {
            return Game.instance ?? (Game.instance = new Game());
        }

        /// <summary>
        /// The Game constructor.
        /// </summary>
        private Game() {
            // window
            Win = new Window("Space Taxi Game v0.1337", 500, AspectRatio.R16X9);

            // event bus
            eventBus = TaxiBus.GetBus();
            eventBus.InitializeEventBus(new List<GameEventType>() {
                GameEventType.InputEvent,      // key press / key release
                GameEventType.WindowEvent,     // messages to the window, e.g. CloseWindow()
                GameEventType.PlayerEvent,     // commands issued to the player object
                GameEventType.GameStateEvent   // Changes the current gamestate using StateMachine
            });
            Win.RegisterEventBus(eventBus);

            // event delegation
            eventBus.Subscribe(GameEventType.InputEvent, this);
            eventBus.Subscribe(GameEventType.WindowEvent, this);
            eventBus.Subscribe(GameEventType.GameStateEvent, this);

            // game timer
            GameTimer = new GameTimer(60); // 60 UPS, no FPS limit

            // statemachine
            Game.stateMachine = StateMachine.GetInstance();
        }

        /// <summary>
        /// Gameloop which runs all the necessary elements of the game.
        /// </summary>
        public void GameLoop() {
            while (Win.IsRunning()) {
                GameTimer.MeasureTime();

                while (GameTimer.ShouldUpdate()) {
                    Win.PollEvents();
                    eventBus.ProcessEvents();
                    Game.stateMachine.ActiveState.UpdateGameLogic();
                }

                if (GameTimer.ShouldRender()) {
                    Win.Clear();
                    Game.stateMachine.ActiveState.RenderState();
                    Win.SwapBuffers();
                }

                if (GameTimer.ShouldReset()) {
                    // 1 second has passed - display last captured ups and fps from the timer
                    Win.Title = "Space Taxi | UPS: " + GameTimer.CapturedUpdates + ", FPS: " +
                                GameTimer.CapturedFrames;
                }
            }
        }

        /// <summary>
        /// Processes different game events.
        /// </summary>
        /// <param name="eventType"> The GameEventType of the event. </param>
        /// <param name="gameEvent"> The GameEvent object. </param>
        public void ProcessEvent(GameEventType eventType, GameEvent<object> gameEvent) {
            if (eventType == GameEventType.WindowEvent) {
                switch (gameEvent.Message) {
                    case "CLOSE_WINDOW":
                        Win.CloseWindow();
                        break;
                    case "SAVE_SCREENSHOT":
                        Win.SaveScreenShot();
                        break;
                }
            }
        }
    }
}
