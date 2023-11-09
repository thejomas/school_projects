using System;
using System.Collections.Generic;
using DIKUArcade.Entities;
using DIKUArcade.Graphics;
using DIKUArcade.Math;

namespace SpaceTaxi_1.Level {
    public class LevelEntityContainers {
        /// <summary>
        /// Used to calculate the x-coordinate of the positional Vec2F (used in CreateLevel-
        /// EntityContainer).
        /// </summary>
        /// <param name="j"> The j from the for-loop in CreateLevelEntityContainer. </param>
        /// <returns> The x-coordinate as a float. </returns>
        private static float XPos(int j) {
            return (float) (1.0 / Level.MAP_WIDTH * j);
        }

        /// <summary>
        /// Used to calculate the y-coordinate of the positional Vec2F (used in EntityContainer).
        /// </summary>
        /// <param name="i"> The i from the for-loop in CreateLevelEntityContainer. </param>
        /// <returns> The y-coordinate as a float. </returns>
        private static float YPos(int i) {
            return Math.Abs((float) i - Level.MAP_HEIGHT + 1) / Level.MAP_HEIGHT;
        }

        /// <summary>
        /// Creates an EntityContainer containing the needed Images (these will be rendered in the
        /// gameloop using *The instance of the current level*.LevelEntities.RenderEntities().
        /// </summary>
        public static void CreateEntityContainers(char[,] map, Dictionary<char, string> symbols) {
            Level.LevelEntities = new EntityContainer();
            Level.PlatformID = new Dictionary<char, EntityContainer>();

            for (int i = 0; i < Level.MAP_HEIGHT; i++) {

                for (int j = 0; j < Level.MAP_WIDTH; j++) {

                    if (map[i, j] == '>') {

                        Level.PlayerStartPosX = XPos(j);
                        Level.PlayerStartPosY = YPos(i);

                    } else if (Level.PlatformKeys.Contains(map[i, j])) {

                        char platformChar = map[i, j];

                        if (Level.PlatformID.ContainsKey(platformChar)) {

                            Level.PlatformID[platformChar].AddStationaryEntity(new StationaryShape(
                                new Vec2F(XPos(j), YPos(i)),
                                new Vec2F((float) 1 / Level.MAP_WIDTH, (float) 1 /
                                                                       Level.MAP_HEIGHT)),
                                new Image("Assets/Images/" + symbols[map[i, j]]));

                        } else {

                            Level.PlatformID.Add(platformChar, new EntityContainer());
                            Level.PlatformID[platformChar].AddStationaryEntity(new StationaryShape(
                                new Vec2F(XPos(j), YPos(i)),
                                new Vec2F((float) 1 / Level.MAP_WIDTH, (float) 1 /
                                                                       Level.MAP_HEIGHT)),
                                new Image("Assets/Images/" + symbols[map[i, j]]));
                        }

                    } else if (map[i, j] != ' ' && map[i, j] != '^') {

                        Level.LevelEntities.AddStationaryEntity(new StationaryShape(
                            new Vec2F(XPos(j), YPos(i)), new Vec2F((float) 1 / Level.MAP_WIDTH,
                                (float) 1 / Level.MAP_HEIGHT)),
                            new Image("Assets/Images/" + symbols[map[i, j]]));
                    }
                }
            }
        }
    }
}