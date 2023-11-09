using System;
using System.IO;
using DIKUArcade.Entities;
using DIKUArcade.EventBus;
using DIKUArcade.Graphics;
using DIKUArcade.Math;
using DIKUArcade.State;
using SpaceTaxi_1.Physics;

namespace SpaceTaxi_1.TaxiStates {
    public class GameRunning : IGameState {
        private static GameRunning instance;

        private GameEventBus<object> eventBus;

        public static Entity BackGroundImage;
        public static Player Player;
        public static Level.Level Level;

        private static CollisionHandler collisionHandler;

        public static GameRunning GetInstance() {
            return GameRunning.instance ?? (GameRunning.instance = new GameRunning());
        }

        /// <summary>
        /// The Game constructor.
        /// </summary>
        public GameRunning() {
            // game assets
            GameRunning.BackGroundImage = new Entity(
                new StationaryShape(new Vec2F(0.0f, 0.0f), new Vec2F(1.0f, 1.0f)),
                new Image(Path.Combine("Assets", "Images", "SpaceBackground.png")));
            GameRunning.BackGroundImage.RenderEntity();

            //Player
            GameRunning.Player = Player.GetInstance();

            // Levels
            GameRunning.Level = new Level.Level();

                // Eventbus
                eventBus = TaxiBus.GetBus();
                eventBus.Subscribe(GameEventType.PlayerEvent, GameRunning.Player);
                eventBus.Subscribe(GameEventType.InputEvent, GameRunning.Player);

            InitializeGameState();

            collisionHandler = new CollisionHandler();
        }

        public void InitializeGameState() {
            // game entities
            GameRunning.Player.SetPosition(SpaceTaxi_1.Level.Level.PlayerStartPosX,
                SpaceTaxi_1.Level.Level.PlayerStartPosY);
            GameRunning.Player.SetExtent(0.045f, 0.045f);
        }

        public void UpdateGameLogic() {
            GameRunning.Player.Move();
            GameRunning.collisionHandler.CheckAllCollisions(GameRunning.Player);
        }

        /// <summary>
        /// Renders the necessary elements in gameRunning
        /// </summary>
        public void RenderState() {
            GameRunning.BackGroundImage.RenderEntity();
            SpaceTaxi_1.Level.Level.LevelEntities.RenderEntities();
            foreach (EntityContainer ent in SpaceTaxi_1.Level.Level.PlatformID.Values) {
                ent.RenderEntities();
            }
            GameRunning.Player.ChooseOrientation();
            GameRunning.Player.Entity.RenderEntity();
        }

        /// <summary>
        /// GameLoop is a member from IGameState, but it is only the GameLoop in Game that is used.
        /// </summary>
        public void GameLoop() {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Is called from the stateMachine itself. Handles any type of key input.
        /// </summary>
        /// <param name="keyValue"></param>
        /// <param name="keyAction"></param>
        public void HandleKeyEvent(string keyValue, string keyAction) {
            switch (keyAction) {
            case "KEY_PRESS":
                KeyPress(keyValue);
                break;
            case "KEY_RELEASE":
                KeyRelease(keyValue);
                break;
            }
        }

        /// <summary>
        /// Handles key input from the user.
        /// </summary>
        /// <param name="key"> The keyinput as a string. </param>
        public void KeyPress(string key) {
            switch (key) {
                case "KEY_ESCAPE":
                    eventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.GameStateEvent,
                            this,
                            "CHANGE_STATE", "GAME_PAUSED", "")
                    );
                    break;
                case "KEY_F12":
                    eventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.WindowEvent,
                            this,
                            "SAVE_SCREENSHOT", "", "")
                    );
                    break;
                case "KEY_UP":
                    eventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.PlayerEvent, GameRunning.Player, "BOOSTER_UPWARDS", "",
                            ""));
                    break;
                case "KEY_LEFT":
                    eventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.PlayerEvent, GameRunning.Player, "BOOSTER_TO_LEFT", "",
                            ""));
                    break;
                case "KEY_RIGHT":
                    eventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.PlayerEvent, GameRunning.Player, "BOOSTER_TO_RIGHT", "",
                            ""));
                    break;
            }
        }

        /// <summary>
        /// Handles the release of keys.
        /// </summary>
        /// <param name="key"> The keyinput as a string. </param>
        public void KeyRelease(string key) {
            switch (key) {
                case "KEY_UP":
                    eventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.PlayerEvent, GameRunning.Player, "STOP_ACCELERATE_UP", "",
                            ""));
                    break;
                case "KEY_LEFT":
                    eventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.PlayerEvent, GameRunning.Player, "STOP_ACCELERATE_LEFT",
                            "", ""));
                    break;
                case "KEY_RIGHT":
                    eventBus.RegisterEvent(
                        GameEventFactory<object>.CreateGameEventForAllProcessors(
                            GameEventType.PlayerEvent, GameRunning.Player, "STOP_ACCELERATE_RIGHT",
                            "", ""));
                    break;
            }
        }
    }
}