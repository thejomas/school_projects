using System;
using DIKUArcade.Graphics;
using DIKUArcade.Math;
using DIKUArcade.EventBus;

namespace SpaceTaxi_1.TaxiStates {
    public class LevelSelect : MainMenu {
        private static LevelSelect instance;

        private Text one;
        private Text two;

        private int maxMenuButtons;

        public new static LevelSelect GetInstance() {
            return LevelSelect.instance ?? (LevelSelect.instance = new LevelSelect());
        }

        /// <summary>
        /// Creates a new level from a levelnumber and sets player position.
        /// </summary>
        /// <param name="levelNumber"> The wanted levelNumber. </param>
        public static void levelSelect(int levelNumber) {
            if (levelNumber != GameRunning.Level.LevelNumber) {
                GameRunning.Level.LevelNumber = levelNumber;
                GameRunning.Level.CreateNewLevel();
            }

            GameRunning.Player.SetPosition(Level.Level.PlayerStartPosX,
                Level.Level.PlayerStartPosY);
        }

        public override void InitializeGameState() {
            maxMenuButtons = 2;
            one = new Text("Level 1", new Vec2F(0.35f, 0.2f), new Vec2F(0.3f, 0.4f));
            one.SetColor(new Vec3I(0, 255, 0));
            two = new Text("Level 2", new Vec2F(0.35f, 0.0f), new Vec2F(0.3f, 0.4f));
            two.SetColor(new Vec3I(255, 0, 0));
            MenuButtons = new[] {one, two};
        }

        public new void UpdateGameLogic() {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Handles key input.
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
                    LevelSelect.levelSelect(0);
                    EventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.GameStateEvent,
                            this,
                            "CHANGE_STATE",
                            "GAME_RUNNING", "")
                    );
                } else if (ActiveMenuButton == 1) {
                    LevelSelect.levelSelect(1);
                    EventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.GameStateEvent,
                            this,
                            "CHANGE_STATE",
                            "GAME_RUNNING", "")
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