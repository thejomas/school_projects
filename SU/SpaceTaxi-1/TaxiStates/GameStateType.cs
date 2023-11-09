using System.Collections.Generic;

namespace SpaceTaxi_1.TaxiStates {
    public enum GameStateType {
        GameRunning,
        GamePaused,
        MainMenu,
        GameOver,
        LevelSelect
    }

    public class StateTransformer {
        static Dictionary<GameStateType, string> stateString =
            new Dictionary<GameStateType, string>{
                { GameStateType.GameRunning, "GAME_RUNNING" },
                { GameStateType.GamePaused, "GAME_PAUSED" },
                { GameStateType.MainMenu, "MAIN_MENU" },
                { GameStateType.GameOver, "GAME_OVER"},
                { GameStateType.LevelSelect, "LEVEL_SELECT"} };

        public static string TransformStateToString(GameStateType state) {
            if (StateTransformer.stateString[state] == null) {
                throw new System.ArgumentException("Unknown GameState");
            }

            return StateTransformer.stateString[state];
        }

        public static GameStateType TransformStringToState(string state) {
            foreach (var keyValuePair in StateTransformer.stateString) {
                if (keyValuePair.Value == state) {
                    return keyValuePair.Key;
                }
            }
            throw new System.ArgumentException("Unknown GameState");
        }
    }
}