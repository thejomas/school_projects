using System;
using DIKUArcade.EventBus;
using DIKUArcade.Graphics;
using DIKUArcade.Math;
using DIKUArcade.State;

namespace SpaceTaxi_1.TaxiStates {
    public class GameOver : IGameState {
        private static GameOver instance;

        private GameEventBus<object> eventBus;

        private Text endText;
        private Text contText;

        // Used in the color method
        bool up = true;
        int r = 5;
        int g = 5;
        int b = 5;

        public static GameOver GetInstance() {
            return GameOver.instance ?? (GameOver.instance = new GameOver());
        }

        public GameOver() {
            endText = new Text("YOU HAVE" + Environment.NewLine + Environment.NewLine
                               + "     DIED", new Vec2F(0.28f, -0.3f), new Vec2F(0.6f, 1f));
            contText = new Text("Press ESC", new Vec2F(0.39f, -0.8f), new Vec2F(0.3f, 1f));
            eventBus = TaxiBus.GetBus();
        }

        public void InitializeGameState() {
            throw new NotImplementedException();
        }

        public void GameLoop() {
            throw new NotImplementedException();
        }

        public void UpdateGameLogic() {
            Color();
        }

        /// <summary>
        /// Changes the color of the endtext constantly.
        /// </summary>
        public void Color() {
            if (b == 255 && (g == 255 && r == 255)) {
                up = false;
                r -= 25;
            } else if (b == 5 && (g == 5 && r == 5)) {
                up = true;
                r += 25;
            }

            if (up) {
                if (r != 255) {
                    r += 25;
                } else if (g != 255) {
                    g += 25;
                } else {
                    b += 25;
                }
            } else {
                if (g != 5) {
                    g -= 25;
                } else if (r != 5) {
                    r -= 25;
                } else {
                    b -= 25;
                }
            }
            endText.SetColor(new Vec3I(r, g, b));
        }


        public void RenderState() {
            GameRunning.BackGroundImage.RenderEntity();
            GameRunning.Player.Explosions.RenderAnimations();
            endText.RenderText();
            contText.SetColor(System.Drawing.Color.White);
            contText.RenderText();
        }

        public void HandleKeyEvent(string keyValue, string keyAction) {
            switch (keyAction) {
            case "KEY_PRESS":
                KeyPress(keyValue);
                break;
            }
        }

        public void KeyPress(string key) {
            switch (key) {
            case "KEY_ESCAPE":
                eventBus.RegisterEvent(
                    GameEventFactory<object>.CreateGameEventForAllProcessors(
                        GameEventType.GameStateEvent,
                        this,
                        "CHANGE_STATE",
                        "MAIN_MENU", ""));
                break;
            }
        }
    }
}