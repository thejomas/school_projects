using System;
using DIKUArcade.EventBus;
using SpaceTaxi_1.TaxiStates;


namespace SpaceTaxi_1.Level {
    public class LevelManager {
        private GameEventBus<object> _eventBus;
            
        
            
        /// <summary>
        /// Creates the next level by removing the current level from the levels list and using
        /// CreateNewLevel, which will then work with the next level from the list.
        /// </summary>
        private void NextLevel() {
            if (!(GameRunning._player.Entity.Shape.Position.Y > 1.0)) {
                return;
            }
            GameRunning._level.levelNumber++;
            try {
                GameRunning._level.CreateNewLevel();
            } catch (ArgumentOutOfRangeException) {
                _eventBus.RegisterEvent(
                    GameEventFactory<object>.CreateGameEventForAllProcessors(
                        GameEventType.WindowEvent,
                        this,
                        "CLOSE_WINDOW", "", "")
                );
            }
            GameRunning._player.SetPosition(Level.playerStartPosX, Level.playerStartPosY);
        }

        public static void levelSelect(int c) {
            if (c != GameRunning._level.levelNumber) {
                GameRunning._level.levelNumber = c;
                GameRunning._level.CreateNewLevel();
            }

            GameRunning._player.SetPosition(Level.playerStartPosX, Level.playerStartPosY);
        }
    }
}