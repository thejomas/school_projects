using System.IO;
using DIKUArcade.Entities;
using DIKUArcade.EventBus;
using DIKUArcade.Graphics;
using DIKUArcade.Math;
using DIKUArcade.State;

namespace SpaceTaxi_1.TaxiStates {
    public class MainMenu : IGameState {
        private static MainMenu instance;

        public GameEventBus<object> EventBus;
        public StateMachine StateMachine;

        private Text newGame;
        private Text levels;
        private Text quit;
        public Text[] MenuButtons;

        public Entity BackGroundImage;

        public int ActiveMenuButton;
        private int maxMenuButtons = 3;

        public MainMenu() {
            BackGroundImage = new Entity(new StationaryShape(new Vec2F(0.0f, 0.0f),
                    new Vec2F(1.0f, 1.0f)),
                new Image(Path.Combine("Assets", "Images", "SpaceBackground.png")));
            newGame = new Text("New Game", new Vec2F(0.35f, 0.2f), new Vec2F(0.3f, 0.4f));
            levels = new Text("Select Level", new Vec2F(0.35f, 0.0f), new Vec2F(0.3f, 0.4f));
            quit = new Text("Quit", new Vec2F(0.35f, -0.2f), new Vec2F(0.3f, 0.4f));
            MenuButtons = new[] {newGame, levels, quit};
            InitializeGameState();
            EventBus = TaxiBus.GetBus();
        }

        public static MainMenu GetInstance() {
            return MainMenu.instance ?? (MainMenu.instance = new MainMenu());
        }

        public void GameLoop() {
            throw new System.NotImplementedException();
        }

        public virtual void InitializeGameState() {
            newGame.SetColor(new Vec3I(0,255,0));
            quit.SetColor(new Vec3I(255,0,0));
            levels.SetColor(new Vec3I(255,0,0));
            ActiveMenuButton = 0;
        }

        public void UpdateGameLogic() {
        }

        /// <summary>
        /// Renders all the necessary elements in menu.
        /// </summary>
        public void RenderState() {
            BackGroundImage.RenderEntity();
            foreach (Text button in MenuButtons) {
                button.RenderText();
            }
        }

        /// <summary>
        /// Handles key input from the user.
        /// </summary>
        /// <param name="keyValue"> The key input as a string. </param>
        /// <param name="keyAction"> A string indicating wether a key has been pressed or released.
        /// </param>
        public virtual void HandleKeyEvent(string keyValue, string keyAction) {
            if (keyAction.Equals("KEY_RELEASE")) {
                return;
            }

            if (keyValue == "KEY_UP") {
                MenuButtons[ActiveMenuButton].SetColor(new Vec3I(255, 0, 0));
                if (ActiveMenuButton <= 0) {
                    ActiveMenuButton = maxMenuButtons - 1;
                } else {
                    ActiveMenuButton--;
                }

                MenuButtons[ActiveMenuButton].SetColor(new Vec3I(0, 255, 0));
            } else if (keyValue == "KEY_DOWN") {
                MenuButtons[ActiveMenuButton].SetColor(new Vec3I(255, 0, 0));
                if (ActiveMenuButton >= maxMenuButtons - 1) {
                    ActiveMenuButton = 0;
                } else {
                    ActiveMenuButton++;
                }

                MenuButtons[ActiveMenuButton].SetColor(new Vec3I(0, 255, 0));
            } else if (keyValue == "KEY_ENTER") {
                if (ActiveMenuButton == 0) {
                    LevelSelect.levelSelect(0);

                    EventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.GameStateEvent,
                            this,
                            "CHANGE_STATE",
                            "GAME_RUNNING", "")
                    );
                } else if (ActiveMenuButton == 1) {
                    EventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.GameStateEvent,
                            this,
                            "CHANGE_STATE",
                            "LEVEL_SELECT", "")
                    );
                } else if (ActiveMenuButton == 2) {
                    EventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.WindowEvent,
                            this,
                            "CLOSE_WINDOW", "", "")
                    );
                }
            } else if (keyValue == "KEY_ESCAPE") {
                EventBus.RegisterEvent(
                    GameEventFactory<object>.CreateGameEventForAllProcessors(
                        GameEventType.WindowEvent,
                        this,
                        "CLOSE_WINDOW", "", "")
                );
            }
        }
    }
}