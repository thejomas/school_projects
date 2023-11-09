using DIKUArcade.EventBus;
using DIKUArcade.Graphics;
using DIKUArcade.Math;

namespace SpaceTaxi_1.TaxiStates {
    public class GamePaused : MainMenu{
        private static GamePaused instance;

        private Text continueGame;
        private Text mainMenu;

        private int maxMenuButtons;

        public new static GamePaused GetInstance() {
            return GamePaused.instance ?? (GamePaused.instance = new GamePaused());
        }

        public override void InitializeGameState() {
            maxMenuButtons = 2;
            continueGame = new Text("Continue", new Vec2F(0.35f, 0.2f), new Vec2F(0.3f, 0.4f));
            continueGame.SetColor(new Vec3I(0,255,0));
            mainMenu = new Text("Main Menu", new Vec2F(0.35f, 0.0f), new Vec2F(0.3f, 0.4f));
            mainMenu.SetColor(new Vec3I(255,0,0));
            MenuButtons = new[] {continueGame, mainMenu};
        }

        /// <summary>
        /// Handles key input
        /// </summary>
        public override void HandleKeyEvent(string keyValue, string keyAction) {
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
                            "CHANGE_STATE", "MAIN_MENU", "")
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